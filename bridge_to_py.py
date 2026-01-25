print("Importing modules and starting the MATLAB Engine API for Python...")
import matlab.engine
import csv
from pathlib import Path

eng = matlab.engine.start_matlab()
print("Matlab engine running!\n")


def test_matlab_connection():
    print("Testing MATLAB connection...")
    result = eng.sqrt(16.0)
    print(f"Square root of 16 is: {result}")


def run_rs_analysis_on_img(path_to_img: Path, verbose=False):
    result = eng.RS(str(path_to_img.resolve()))
    if verbose:
        print(f"RSAnalysis result: {result}")
    return result


def plot_rs_analysis_on_img(path_to_img: Path):
    eng.computeAndPlot(str(path_to_img.resolve()), nargout=0)


def analyze_images_to_csv(
    start_num: int,
    end_num: int,
    filename_template: str,
    output_csv: str,
    verbose: bool = True
):
    """
    Analyze multiple images and save results to CSV.
    
    important variables:
        start_num: Starting number for image filenames
        end_num: Ending number (inclusive) for image filenames
        filename_template: Template string with {} for the number, e.g., "{}_stego.png"
        output_csv: Path to output CSV file
        verbose: Whether to print progress
    """
    results = []
    # name of the folder containing the images, assumed to be in the same directory as this script
    images_dir = Path(__file__).parent / "stegoimages"
    
    for i in range(start_num, end_num + 1):
        filename = filename_template.format(i)
        image_path = images_dir / filename
        
        if verbose:
            print(f"Processing: {filename}...", end=" ")
        
        try:
            result = run_rs_analysis_on_img(image_path)
            results.append({
                "image_number": i,
                "filename": filename,
                "rs_result": result
            })
            if verbose:
                print(f"Result: {result}")
        except Exception as e:
            print(f"Error processing {filename}: {e}")
            results.append({
                "image_number": i,
                "filename": filename,
                "rs_result": "ERROR"
            })
    
    # results to CSV
    with open(output_csv, "w", newline="") as csvfile:
        fieldnames = ["image_number", "filename", "rs_result"]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        
        writer.writeheader()
        writer.writerows(results)
    
    print(f"\nResults saved to: {output_csv}")
    return results


if __name__ == "__main__":
    # change start_num=1, end_num=200, 
    analyze_images_to_csv(
        start_num=1,
        end_num=200,                      # change this to your last image number
        filename_template="stego{}.png", # change if your naming is different
        output_csv="rs_analysis_results.csv",
        verbose=True
    )