print("Importing modules and starting the MATLAB Engine API for Python...")
import matlab.engine
from pathlib import Path
eng = matlab.engine.start_matlab()
print("Matlab engine running!\n")


def test_matlab_connection():
  print("Testing MATLAB connection...")
  result = eng.sqrt(16.0)
  print(f"Square root of 16 is: {result}")


def run_rs_analysis_on_img(path_to_img: Path, verbose = False):
  result = eng.RS(str(path_to_img.resolve()))
  if verbose:
    print(f"RSAnalysis result: {result}")
  return result


def plot_rs_analysis_on_img(path_to_img: Path):
  eng.computeAndPlot(str(path_to_img.resolve()), nargout=0)

if __name__ == "__main__":
  # test_matlab_connection()
  
  # run_rs_analysis_on_img(
  #   Path(__file__).parent / "images" / "1_stego.png",
  #   True
  # )

  plot_rs_analysis_on_img(
    Path(__file__).parent / "images" / "1_cover.png"
  )