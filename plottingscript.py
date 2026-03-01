import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import roc_curve, roc_auc_score, accuracy_score, confusion_matrix

# ============================================================
# 1. FILE PATHS — adjust these
# ============================================================
clean_csv = "rs_clean.csv"

# Dictionary: embedding rate → csv file path
stego_csvs = {
    0.05: "rs_lsb_005.csv",
    0.10: "rs_lsb_010.csv",
    0.25: "rs_lsb_025.csv",
    0.50: "rs_lsb_050.csv",
    0.75: "rs_lsb_075.csv",
    1.00: "rs_lsb_100.csv",
}

# ============================================================
# 2. LOAD CLEAN DATA
# ============================================================
clean = pd.read_csv(clean_csv)
clean["label"] = 0
print(f"Loaded {len(clean)} clean images")
print(f"  Clean RS estimates — mean: {clean['rs_result'].mean():.4f}, "
      f"std: {clean['rs_result'].std():.4f}")

# ============================================================
# 3. COMPUTE METRICS PER EMBEDDING RATE
# ============================================================
results = []

for rate, path in sorted(stego_csvs.items()):
    stego = pd.read_csv(path)
    stego["label"] = 1

    # Combine clean + stego
    combined = pd.concat([
        clean[["rs_result", "label"]],
        stego[["rs_result", "label"]]
    ], ignore_index=True)

    labels = combined["label"].values
    scores = combined["rs_result"].values

    # ROC
    fpr, tpr, thresholds = roc_curve(labels, scores)
    auc = roc_auc_score(labels, scores)

    # Best threshold (Youden's J)
    j_scores = tpr - fpr
    best_idx = np.argmax(j_scores)
    best_threshold = thresholds[best_idx]

    # Accuracy
    preds = (scores > best_threshold).astype(int)
    acc = accuracy_score(labels, preds)
    cm = confusion_matrix(labels, preds)

    results.append({
        "rate": rate,
        "auc": auc,
        "accuracy": acc,
        "threshold": best_threshold,
        "n_clean": len(clean),
        "n_stego": len(stego),
        "TP": cm[1, 1],
        "TN": cm[0, 0],
        "FP": cm[0, 1],
        "FN": cm[1, 0],
        "fpr": fpr,
        "tpr": tpr,
        "mean_rs_stego": stego["rs_result"].mean(),
    })

    print(f"Rate {rate:.2f}: AUC={auc:.3f}, Acc={acc:.1%}, "
          f"Threshold={best_threshold:.4f}, "
          f"Mean RS estimate={stego['rs_result'].mean():.4f}")

# ============================================================
# 4. PRINT TABLE
# ============================================================
print("\n" + "=" * 80)
print(f"{'Rate':>6} | {'AUC':>6} | {'Acc':>7} | {'Thresh':>8} | "
      f"{'Mean RS':>8} | {'TP':>4} | {'TN':>4} | {'FP':>4} | {'FN':>4}")
print("-" * 80)
for r in results:
    print(f"{r['rate']:>6.2f} | {r['auc']:>6.3f} | {r['accuracy']:>6.1%} | "
          f"{r['threshold']:>8.4f} | {r['mean_rs_stego']:>8.4f} | "
          f"{r['TP']:>4} | {r['TN']:>4} | {r['FP']:>4} | {r['FN']:>4}")
print("=" * 80)

# ============================================================
# 5. EXPORT LATEX TABLE
# ============================================================
table_df = pd.DataFrame([{
    "Rate": f"{r['rate']:.2f}",
    "AUC": f"{r['auc']:.3f}",
    "Accuracy": f"{r['accuracy']:.1%}",
    r"Threshold $\tau$": f"{r['threshold']:.4f}",
    "TP": r["TP"],
    "TN": r["TN"],
    "FP": r["FP"],
    "FN": r["FN"],
} for r in results])

print("\nLaTeX:\n")
print(table_df.to_latex(index=False, escape=False))

# ============================================================
# 6. PLOT ROC CURVES
# ============================================================
fig, ax = plt.subplots(figsize=(8, 6))
colors = plt.cm.viridis(np.linspace(0.15, 0.85, len(results)))

for r, color in zip(results, colors):
    ax.plot(r["fpr"], r["tpr"],
            label=f'r = {r["rate"]:.2f} (AUC = {r["auc"]:.3f})',
            color=color, linewidth=2)

ax.plot([0, 1], [0, 1], 'k--', linewidth=1, alpha=0.5, label="Random")
ax.set_xlabel("False Positive Rate", fontsize=13)
ax.set_ylabel("True Positive Rate", fontsize=13)
ax.set_title("RS Analysis — ROC Curves by Embedding Rate", fontsize=14)
ax.legend(loc="lower right", fontsize=10)
ax.set_xlim([0, 1])
ax.set_ylim([0, 1.02])
ax.grid(True, alpha=0.3)
plt.tight_layout()
plt.savefig("roc_curves.pdf")
plt.savefig("roc_curves.png", dpi=300)
plt.show()

# ============================================================
# 7. PLOT ACCURACY & AUC vs EMBEDDING RATE
# ============================================================
fig, ax = plt.subplots(figsize=(8, 5))

rate_vals = [r["rate"] for r in results]
acc_vals  = [r["accuracy"] * 100 for r in results]
auc_vals  = [r["auc"] * 100 for r in results]

ax.plot(rate_vals, acc_vals, 'bo-', linewidth=2, markersize=8, label="Accuracy")
ax.plot(rate_vals, auc_vals, 'rs--', linewidth=2, markersize=8, label="AUC × 100")
ax.axhline(y=50, color='gray', linestyle=':', linewidth=1, label="Chance (50%)")

ax.set_xlabel("Embedding Rate", fontsize=13)
ax.set_ylabel("%", fontsize=13)
ax.set_title("RS Analysis — Performance vs Embedding Rate", fontsize=14)
ax.legend(fontsize=11)
ax.set_ylim([40, 105])
ax.grid(True, alpha=0.3)
plt.tight_layout()
plt.savefig("accuracy_vs_rate.pdf")
plt.savefig("accuracy_vs_rate.png", dpi=300)
plt.show()