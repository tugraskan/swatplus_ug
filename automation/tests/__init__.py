"""
Test package initialization for SWAT+ automation tests.
"""

import unittest
import sys
from pathlib import Path

# Add the automation src directory to the path for testing
automation_root = Path(__file__).parent.parent
src_path = automation_root / "src"
sys.path.insert(0, str(src_path))


def run_all_tests():
    """Run all tests in the test suite."""
    loader = unittest.TestLoader()
    suite = loader.discover(start_dir=str(Path(__file__).parent), pattern='test_*.py')
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)
    return result.wasSuccessful()


if __name__ == '__main__':
    success = run_all_tests()
    sys.exit(0 if success else 1)