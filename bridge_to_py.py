print("Importing modules and starting the MATLAB Engine API for Python...")
import matlab.engine
from pathlib import Path
eng = matlab.engine.start_matlab()
print("Matlab engine running!\n")


def test_matlab_connection():
  print("Testing MATLAB connection...")
  result = eng.sqrt(16.0)
  print(f"Square root of 16 is: {result}")


def test_matlab_func():
  print("Testing custom MATLAB function...")
  result = eng.testFunc(5, 4)
  print(f"Result: {result}")


def run_rs_analysis_on_img(path_to_img: Path, verbose = False):
  result = eng.RS(str(path_to_img.resolve()))
  if verbose:
    print(f"RSAnalysis result: {result}")
  return result


if __name__ == "__main__":
  # test_matlab_connection()
  # test_matlab_func()
  
  run_rs_analysis_on_img(
    Path("C:\\Users\\Martin\\Code\\ThesisWork\\steganalysis\\1_cover.png"),
    True
  )
