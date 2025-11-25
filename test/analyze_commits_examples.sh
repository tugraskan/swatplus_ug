#!/bin/bash

# Example usage of the analyze_commits.py tool
# This demonstrates how to use the tool to analyze commit differences

echo "=========================================="
echo "SWAT+ Commit Analysis Tool - Examples"
echo "=========================================="
echo ""

echo "1. Detecting NEW INPUT FILES:"
echo "   Comparing commits that added new input files"
echo "   $ python3 test/analyze_commits.py ddbceaa 3a74608"
echo ""
python3 test/analyze_commits.py ddbceaa 3a74608
echo ""
echo ""

echo "2. Detecting CHANGES in EXISTING INPUT FILES:"
echo "   Comparing commits with modifications to existing files"
echo "   $ python3 test/analyze_commits.py 54ddb5f 118c27b"
echo ""
python3 test/analyze_commits.py 54ddb5f 118c27b | head -55
echo "   ... (output truncated)"
echo ""
echo ""

echo "3. Detecting SUBROUTINE and MODULE changes:"
echo "   Comparing commits with source code changes"
echo "   $ python3 test/analyze_commits.py efd8376 cbaf541"
echo ""
python3 test/analyze_commits.py efd8376 cbaf541
echo ""
echo ""

echo "4. Using relative commit references:"
echo "   $ python3 test/analyze_commits.py HEAD~5 HEAD~3"
echo ""
python3 test/analyze_commits.py HEAD~5 HEAD~3
echo ""
echo ""

echo "=========================================="
echo "For more information, see doc/CommitAnalysis.md"
echo "=========================================="
