// CEG6850FINAL.cpp : This file contains the 'main' function. Program execution begins and ends there.
//
// Inputs:
//          1) L1 - character string list of blocks at location 1
//          2) L2 - character string list of blocks at location 2
//          3) Output Directory


#include <iomanip>
#include <fstream>
#include "isInputValid.hpp"


using namespace std;

string fileOut;

string L1;
string L2;

string arm1; 
string arm2;

string goal = "abcdefghijklmn";
string charInPlace;
int goalIdx;
int goalLocation;

int state(-1);

void file(string fileName)
{
    fileOut = fileName;
}

void setL1(string l1)
{
    L1 = l1;
}

void setL2(string l2)
{
    L2 = l2;
}

string blockdisplay(string str)
{
    string strOut = "";

    string ob("[");
    string cb("]");
    string b("|");

    strOut.push_back(ob[0]);

    for (int i = 0; i < str.size(); i++)
    {
        strOut.push_back(str[i]);
        if (i + 1 < str.size()) { strOut.push_back(b[0]); }
    }

    strOut.push_back(cb[0]);

    return strOut;
}

void incrementState(/*state*/)
{
    state++;

    ofstream out;
    out.open(fileOut, ofstream::app);
    out << endl << "_________________________" << "State #" << state << "_________________________" << endl
        << setw(10) << "T | " << setw(25) << blockdisplay(arm1) << setw(10) << "(ARM1)" << endl
        << "(L1)  " << "A | " << blockdisplay(L1) << endl
        << setw(10) << "B | " << endl
        << "(L2)  " << "L | " << blockdisplay(L2) << endl
        << setw(10) << "E | " << setw(25) << blockdisplay(arm2) << setw(10) << "(ARM2)" << endl
        << "____________________________________________________________" << endl << endl;
    out.close();

    cout    << endl << "_________________________" << "State #" << state << "_________________________" << endl
            << setw(10) << "T | " << setw(25) << blockdisplay(arm1) << setw(10) << "(ARM1)" << endl
            << "(L1)  " << "A | " << blockdisplay(L1) << endl
            << setw(10)  << "B | " << endl
            << "(L2)  " << "L | " << blockdisplay(L2) << endl
            << setw(10)  << "E | " << setw(25) << blockdisplay(arm2) << setw(10) << "(ARM2)" << endl
            << "____________________________________________________________" << endl<< endl;

}

bool NOOP()
{
    if (charInPlace == goal)
    {
        return true;
    }
}

int findCharInL1(/*string L1*/)
{
    for (int i = 0; i < L1.size(); i++)
    {
        if (goal[goalIdx] == L1[i])
        {
            return i;
            break;
        }
    }
    return -1;
}
int findCharInL2(/*string L2*/)
{
    for (int i = 0; i < L2.size(); i++)
    {
        if (goal[goalIdx] == L2[i])
        {
            return i;
            break;
        }
    }
    return -1;
}

void firstMove(/*string L1, string L2*/)
{
    int i = findCharInL1(/*L1*/);
    int i2 = findCharInL2(/*L2*/);

    if ( i >= 0)
    {
        int szL1 = L1.size();
        for (int ii = szL1-1; ii > i; ii--)
        {
                //pick up
                arm1 = L1[L1.size() - 1];
                incrementState();

                //Unstack
                L1.pop_back();
                incrementState();

                //move
                incrementState();

                //Stack
                L2.push_back(arm1[0]);
                incrementState();

                //put down
                arm1.pop_back();
                incrementState();

                // move arm1
                incrementState();
        }
        
        //pickup
        arm1 = L1[i];
        incrementState();

        //Unstack
        L1.pop_back();
        incrementState();

        int szL1_1 = L1.size();
        for (int iii = 0; iii < szL1_1; iii++)
        {
            // pick up
            arm2 = L1[L1.size() - 1];
            incrementState();

            //Unstack
            L1.pop_back();
            incrementState();

            // move
            incrementState();

            //Stack
            L2.push_back(arm2[0]);
            incrementState();

            //putdown
            arm2.pop_back();
            incrementState();
        }

        // move arm1
        incrementState();

        //stack
        L1.push_back(arm1[0]);
        incrementState();

        //putdown
        arm1.pop_back();

        charInPlace.push_back(goal[goalIdx]);
        goalIdx++;

        goalLocation = 1;
    }
    else if (i2 >= 0)
    {
        int szL2 = L2.size();
        for (int ii = szL2-1; ii > i2; ii--)
        {
                //pick up
                arm1 = L2[L2.size() - 1];
                incrementState();

                //Unstack
                L2.pop_back();
                incrementState();

                //move
                incrementState();

                //Stack
                L1.push_back(arm1[0]);
                incrementState();

                //put down
                arm1.pop_back();
                incrementState();
        }
        // move arm1
        incrementState();

        //pickup
        arm1 = L2[i2];
        incrementState();

        //Unstack
        L2.pop_back();
        incrementState();

        int szL2_1 = L2.size();
        for (int iii = 0; iii < szL2_1; iii++)
        {
            // pick up
            arm2 = L2[L2.size() - 1];
            incrementState();

            //Unstack
            L2.pop_back();
            incrementState();

            // move
            incrementState();

            //Stack
            L1.push_back(arm2[0]);
            incrementState();

            //putdown
            arm2.pop_back();
            incrementState();

            // move arm1
            incrementState();
        }

        //stack
        L2.push_back(arm1[0]);
        incrementState();

        //putdown
        arm1.pop_back();

        charInPlace.push_back(goal[goalIdx]);
        goalIdx++;

        goalLocation = 2;
    }
}

void finishMoves(/*string L1, string L2*/)
{
    if (goalLocation == 1)
    {
        int i = findCharInL1(/*L1*/);
        int i2 = findCharInL2(/*L2*/);
        if (i >= 0)
        {
            int szL1 = L1.size();
            for (int ii = szL1-1; ii > i; ii--) 
            {
                    //pick up
                    arm1 = L1[L1.size() - 1];
                    incrementState();

                    //Unstack
                    L1.pop_back();
                    incrementState();

                    //move
                    incrementState();

                    //Stack
                    L2.push_back(arm1[0]);
                    incrementState();

                    //put down
                    arm1.pop_back();
                    incrementState();

                    // move arm1
                    incrementState();
            }

            //pickup
            arm1 = L1[i];
            incrementState();

            //Unstack
            L1.pop_back();
            incrementState();

            int restack = charInPlace.size();
            if (restack < L1.size())
            {
                int szL1 = L1.size();
                for (int r = szL1-1; r >= restack; r--)
                {
                    //pickup
                    arm2 = L1[r];
                    incrementState();

                    //unstack
                    L1.pop_back();
                    incrementState();

                    //move arm
                    incrementState();

                    //stack
                    L2.push_back(arm2[0]);
                    incrementState();

                    //putdown
                    arm2.pop_back();
                    incrementState();
                    
                    //move arm back
                    incrementState();
                }
            }
            //stack
            L1.push_back(arm1[0]);      //We've placed our goal block
            incrementState();

            //put down
            arm1.pop_back();
            incrementState();

            charInPlace.push_back(goal[goalIdx]);
            goalIdx++;
        }
        else if (i2 >= 0)
        {
            int szL2 = L2.size();
            for (int ii = szL2-1; ii > i2; ii--)
            {
                //pick up
                arm1 = L2[L2.size() - 1];
                incrementState();

                //Unstack
                L2.pop_back();
                incrementState();

                //move
                incrementState();

                //Stack
                L1.push_back(arm1[0]);
                incrementState();

                //put down
                arm1.pop_back();
                incrementState();

                // move arm1
                incrementState();
            }

            //pickup
            arm1 = L2[i2];
            incrementState();

            //Unstack
            L2.pop_back();
            incrementState();

            int restack = charInPlace.size();
            if (restack < L1.size())
            {
                int szL1 = L1.size();
                for (int r = szL1 - 1; r >= restack; r--)
                {
                    //pickup
                    arm2 = L1[r];
                    incrementState();

                    //unstack
                    L1.pop_back();
                    incrementState();

                    //move arm
                    incrementState();

                    //stack
                    L2.push_back(arm2[0]);
                    incrementState();

                    //putdown
                    arm2.pop_back();
                    incrementState();

                    //move arm back
                    incrementState();
                }
            }
            //stack
            L1.push_back(arm1[0]);      //We've placed our goal block
            incrementState();

            //put down
            arm1.pop_back();
            incrementState();

            charInPlace.push_back(goal[goalIdx]);
            goalIdx++;
        }
    }
    else if (goalLocation == 2)
    {
        int i = findCharInL1(/*L1*/);
        int i2 = findCharInL2(/*L2*/);
        if (i >= 0)
        {
            int szL1 = L1.size();
            for (int ii = szL1-1; ii > i; ii--)
            {
                //pick up
                arm1 = L1[L1.size() - 1];
                incrementState();

                //Unstack
                L1.pop_back();
                incrementState();

                //move
                incrementState();

                //Stack
                L2.push_back(arm1[0]);
                incrementState();

                //put down
                arm1.pop_back();
                incrementState();

                // move arm1
                incrementState();
            }

            //pickup
            arm1 = L1[i];
            incrementState();

            //Unstack
            L1.pop_back();
            incrementState();

            int restack = charInPlace.size();
            if (restack < L2.size())
            {
                int szL2 = L2.size();
                for (int r = szL2 - 1; r >= restack; r--)
                {
                    //pickup
                    arm2 = L2[r];
                    incrementState();

                    //unstack
                    L2.pop_back();
                    incrementState();

                    //move arm
                    incrementState();

                    //stack
                    L1.push_back(arm2[0]);
                    incrementState();

                    //putdown
                    arm2.pop_back();
                    incrementState();

                    //move arm back
                    incrementState();
                }
            }
            //stack
            L2.push_back(arm1[0]);      //We've placed our goal block
            incrementState();

            //put down
            arm1.pop_back();
            incrementState();

            charInPlace.push_back(goal[goalIdx]);
            goalIdx++;
        }
        else if (i2 >= 0)
        {
            int szL2 = L2.size();
            for (int ii = szL2-1; ii > i2; ii--)
            {
                //pick up
                arm1 = L2[L2.size() - 1];
                incrementState();

                //Unstack
                L2.pop_back();
                incrementState();

                //move
                incrementState();

                //Stack
                L1.push_back(arm1[0]);
                incrementState();

                //put down
                arm1.pop_back();
                incrementState();

                // move arm1
                incrementState();
            }

            //pickup
            arm1 = L2[i];
            incrementState();

            //Unstack
            L2.pop_back();
            incrementState();
            
            int restack = charInPlace.size();
            if (restack < L2.size())
            {
                int szL2 = L2.size();
                for (int r = szL2 - 1; r >= restack; r--)
                {
                    //pickup
                    arm2 = L2[r];
                    incrementState();

                    //unstack
                    L2.pop_back();
                    incrementState();

                    //move arm
                    incrementState();

                    //stack
                    L1.push_back(arm2[0]);
                    incrementState();

                    //putdown
                    arm2.pop_back();
                    incrementState();

                    //move arm back
                    incrementState();
                }
            }
            //stack
            L2.push_back(arm1[0]);      //We've placed our goal block
            incrementState();

            //put down
            arm1.pop_back();
            incrementState();

            charInPlace.push_back(goal[goalIdx]);
            goalIdx++;
        }
    }
}

int main(int argc, char** argv)
{
    // Error handling on inputs
    // Note: This does not handle any errors that may arise from the output location argument
    isInputValid check(argc, argv);
    if (check.areInputsValid() != 0) { return check.areInputsValid(); }

    file(argv[3]);

    //Initialize States and Locations
    goalIdx = 0;
    setL1(argv[1]);
    setL2(argv[2]);
    incrementState();


    firstMove();

    while (!NOOP())
    {
        finishMoves();
    }

    return 0;
}

