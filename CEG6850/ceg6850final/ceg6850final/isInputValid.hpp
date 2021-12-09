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
			L1 = argv[3];
			L2 = argv[4];

			returnVal -= areBlocksValid(L1, L2);
			returnVal -= areBlocksRepeated(L1, L2);

			returnVal -= areBlocksValid(L3, L4);
			returnVal -= areBlocksRepeated(L3, L4);
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
	std::string L3;
	std::string L4;
};