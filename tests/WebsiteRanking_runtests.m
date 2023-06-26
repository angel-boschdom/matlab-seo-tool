%% Script to run tests
% This script runs all the unit tests that are the child classes of
% matlab.unittest.TestCase in the project.
% Unit test classes are automatically detected by
% the matlab.unittest.TestSuite.fromFolder function.

relstr = matlabRelease().Release;
disp("This is MATLAB " + relstr)

%% Create test suite

prjroot = currentProject().RootFolder;

suite = matlab.unittest.TestSuite.fromFolder(fullfile(prjroot, "tests"), "IncludingSubfolders",true);

%% Filter test suites that require an API key

suiteNames = {suite.Name};
suite(startsWith(suiteNames, "tChatGPT")) = [];

%% Create test runner

runner = matlab.unittest.TestRunner.withTextOutput( ...
          "OutputDetail", matlab.unittest.Verbosity.Detailed);

%% JUnit style test result

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
          fullfile(prjroot, "tests", "TestResults_"+relstr+".xml"));

addPlugin(runner, plugin)

%% Run tests

results = run(runner, suite);
assertSuccess(results);
disp(results)