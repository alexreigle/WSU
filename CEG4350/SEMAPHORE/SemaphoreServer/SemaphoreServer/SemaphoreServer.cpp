#pragma once
#include <Windows.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <stdlib.h>
#include <time.h>
#include <stdexcept>

using namespace std;

//Global Variables
int ConsumedIntegers = 0;
int head, tail = 0;  //Logical Ring Buffer Variables
int buffer[10] = { -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 };
vector<int> dataProduced(100); int P = 0;
vector<int> dataConsumed(100); int C = 0;


int Producer();
int Consumer(int);
void NewFile(string);
void WriteToFile(int, vector<int>);
void WriteToBuffer(int, int&);
int ReadFromBuffer(int&);
bool IsFull();
bool IsEmpty(int&, int&);

HANDLE hSemaphore;

DWORD WINAPI ThreadProduce(LPVOID lpParam)
{
    while (ConsumedIntegers < 100)
    {
        WaitForSingleObject(hSemaphore, INFINITE);
        if (!IsFull()) //Check that there are slots to place produced data
        {
            //Produce Data
            int dataP = Producer();
            WriteToBuffer(dataP, head);
            //cout << "Entered Producer: " << ConsumedIntegers << " head = " << head << " tail = " << tail << " Data Produced:" << dataP << endl;
            Sleep(1000);                    //The Sleep() function is used to delay the program by 1 second each time the Producer() is called.
        }                                   //This gives time(NULL), which is the seed to srand(), time to change value and produce a more random int.
        ReleaseSemaphore(hSemaphore, 1, 0);
    }
    return 0;
}
DWORD WINAPI ThreadConsume(LPVOID lpParam)
{
    while (ConsumedIntegers < 100)
    {
        WaitForSingleObject(hSemaphore, INFINITE);
        if (!IsEmpty(head, tail)) //Check that there is data to consume
        {
            int dataC = ReadFromBuffer(tail);

            //Cosume Data
            Consumer(dataC); 
            ConsumedIntegers++;
            //cout << "Entered Consumer: " << ConsumedIntegers << " head = " << head << " tail = " << tail << endl;
        }
        ReleaseSemaphore(hSemaphore, 1, 0);
    }
    return 0;
}

int main()
{
    cout << "\t\t----- SEMAPHORE IPC -----" << endl;

    //Local Variable
    HANDLE hThreadP, hThreadC;

    //Create Semaphore
    hSemaphore = CreateSemaphore(
        NULL,           //Security Attribute
        1,              //Initial Count
        1,              //Max Count
        L"MYSEMAPHORE"  //Semaphore Name
    );
    if (hSemaphore == NULL) { cout << "CreateSemaphore Failed with Error # " << GetLastError() << endl; }
   // else { cout << "CreateSemaphore Success." << endl; }

    //Create Threads
    hThreadP = CreateThread(
        NULL,           //Security Attribute
        0,              //Stack Size (Default)
        &ThreadProduce, //Start Function
        NULL,           //Thread Parameter
        0,              //Creation Flags
        0               //ThreadID
    );
    hThreadC = CreateThread(NULL, 0, &ThreadConsume, NULL, 0, 0 );

    //Wait for Signaled Object
    WaitForSingleObject(hThreadP, INFINITE);
    WaitForSingleObject(hThreadC, INFINITE);

    //Close Thread Handles
    CloseHandle(hThreadP);
    CloseHandle(hThreadC);

    //Close Semaphore Handle
    CloseHandle(hSemaphore);

    WriteToFile(1, dataProduced);
    WriteToFile(2, dataConsumed);
    return 0;
}

int Producer()
{
    srand(time(NULL));
    int data = rand() % 100 + 1;
    if (P > 99) {} //Index of data must be in range
    else
    { //Produced Data
        dataProduced[P] = data;
        P++;
    }
    return data;
}
int Consumer(int val)
{
    if (C > 99) {} //Index of data must be in range
    else
    { //Consumed Data
        dataConsumed[C] = val;
        C++;
    }
    
    return 0;
}

void WriteToFile(int Flag, vector<int> data)
{ //Save and Print the data
    if (Flag == 1)
    { //Producer Data
        string path = "C:\\Users\\reigl\\OneDrive\\Documents\\Academia\\Courses\\CEG4350\\FinalSolutions\\SEMAPHORE\\Producer.txt";
        NewFile(path);
        fstream file;
        file.open(path);
        int sz = data.size();
        cout << "\nData Produced: " << endl;
        for (int i = 0; i < sz; i++)
        {
            cout << data[i] << " ";
            file << data[i] << endl;
           
        } cout << endl;
        file.close();
    }
    else if (Flag == 2)
    {//Consumer Data
        string path = "C:\\Users\\reigl\\OneDrive\\Documents\\Academia\\Courses\\CEG4350\\FinalSolutions\\SEMAPHORE\\Consumer.txt";
        NewFile(path);
        fstream file;
        file.open(path);
        int sz = data.size();
        cout << "\nData Consumed: " << endl;
        for (int i = 0; i < sz; i++)
        {
            cout << data[i] << " ";
            file << data[i] << endl;
            
        } cout << endl;
        file.close();
    }
    else
    {
        cout << "WriteToFile Error - Incorrect File Path." << endl;
    }
}
void NewFile(string file)
{
    ofstream a;
    a.open(file);
    a.close();
}


void WriteToBuffer(int val, int& head)
{
    buffer[head] = val;
    head = (head+1)%10;
}
int ReadFromBuffer(int& tail)
{
    int val = buffer[tail];
    buffer[tail] = -1;
    tail = (tail +1)%10;
    return val;
}
bool IsFull()
{
    int emptyslots = 0;
    for (int i = 0; i < sizeof(buffer); i++)
    {
        if (buffer[i] == -1) { emptyslots++; }
    }

    if (emptyslots == 0) { return true; }
    else { return false; }
}
bool IsEmpty(int &head, int &tail)
{
    int emptyslots = 0;
    for (int i = 0; i < sizeof(buffer); i++)
    {
        if (buffer[i] == -1) { emptyslots++; }
    }

    if (head == tail) { return true; }
    else if (emptyslots == 10) { return true; }
    else { return false; }
}