#pragma once

#include "isInputValid.hpp"
#include <iostream>

int isInputValid::isCorrectNumInputs(int argc)
{
    if (argc != 6)
    {
        std::cout << "Error: Incorrect Number of Inputs (" << argc << "). \n\n"
            << "The three inputs required are:\n"
            << "          1) Initial State: L1 block list (char[0-14])\n"
            << "          2) Initial State: L2 block list (char[0-14])\n"
            << "          3) Final State:   L1 block list (char[0-14])\n"
            << "          4) Final State:   L2 block list (char[0-14])\n"
            << "          5) Output folder(string)" << std::endl;
        return -1;
    }
    return 0;
}

int isInputValid::isCorrectLengthInputs(char** argv)
{
    if (strlen(argv[1]) + strlen(argv[2]) != 14 && strlen(argv[3]) + strlen(argv[4]) != 14)
    {
        std::cout << "Error: Incorrect Length of Location Inputs (must be 14 total). \n\n"
            << "          1) Initial State: L1 block list (char[0-14], currently char[" << strlen(argv[1]) << "])\n"
            << "          2) Initial State: L2 block list (char[0-14], currently char[" << strlen(argv[2]) << "])\n" 
            << "          3) Final State:   L1 block list (char[0-14], currently char[" << strlen(argv[3]) << "])\n"
            << "          4) Final State:   L2 block list (char[0-14], currently char[" << strlen(argv[4]) << "])" << std::endl;
        return -2;
    }
    return 0;
}

int isInputValid::areBlocksValid(std::string L1, std::string L2)
{
    std::string blocks("abcdefghijklmn");
    for (int itr = 0; itr < blocks.size(); itr++)
    {
        L1.erase(std::remove(L1.begin(), L1.end(), blocks[itr]), L1.end());
        L2.erase(std::remove(L2.begin(), L2.end(), blocks[itr]), L2.end());
    }
    if (!L1.empty())
    {
        std::cout << "Error: Invalid L1 input. The input " << L1 << " is/are not a valid block." << std::endl;
        return -3;
    }
    else if (!L2.empty())
    {
        std::cout << "Error: Invalid L2 input. The input " << L2 << " is/are not a valid block." << std::endl;
        return -3;
    }
    return 0;
}

int isInputValid::areBlocksRepeated(std::string L1, std::string L2)
{
    std::string testL1L2 = L1 + L2;

    for (int itr = 0; itr < testL1L2.size(); itr++)
    {
        char c = testL1L2[itr];
        int numOccurrences = 0;
        char repeat;

        for (int i = 0; i < L1.size(); i++)
        {
            if (L1[i] == c)
            {
                numOccurrences++;
                if (numOccurrences > 1) { repeat = c; }
            }
        }
        for (int i = 0; i < L2.size(); i++)
        {
            if (L2[i] == c)
            {
                numOccurrences++;
                if (numOccurrences > 1) { repeat = c; }
            }
        }

        if (numOccurrences > 1)
        {
            std::cout << "Error: Only one copy of each block (" << repeat << ") is allowed." << std::endl;
            return -4;
        }
    }
    return 0;
}

int isInputValid::areInputsValid()
{
    return returnVal;
}