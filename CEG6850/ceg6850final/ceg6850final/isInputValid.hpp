#pragma once

#include <iostream>
#include <regex>
#include <string>

class isInputValid
{
public:
	isInputValid(int argc, char** argv)
	{
		returnVal = 0;
		returnVal -= isCorrectNumInputs(argc);
		returnVal -= isCorrectLengthInputs(argv);
		if (returnVal == 0)
		{
			L1 = argv[1];
			L2 = argv[2];

			returnVal -= areBlocksValid(L1, L2);
			returnVal -= areBlocksRepeated(L1, L2);
		}
	}

	int isCorrectNumInputs(int argc);
	int isCorrectLengthInputs(char** argv);
	int areBlocksValid(std::string, std::string);
	int areBlocksRepeated(std::string, std::string);

	int areInputsValid();

private:
	int returnVal;
	std::string L1;
	std::string L2;
};