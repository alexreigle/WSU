#pragma once
#include <Windows.h>
#include <iostream>
#include <vector>
#include <string>
#include <fstream>

using namespace std;

void Consumer(vector<int>);
void newfile(string);
int write(string, vector<int>);

int main()
{
    cout << "\t\t-----MAILSLOTS SERVER-----" << endl;
    //CreateMailslots Local Variables
    HANDLE hSlots;
    //ReadFile Local Variables
    BOOL    bReadFile;
    DWORD   dwNoBytesRead;
    char    szReadBuffer[1023];
    DWORD   dwReadFileBufferSize = sizeof(szReadBuffer);

    //CreateMailslots
    hSlots = CreateMailslot(
        L"\\\\.\\mailslot\\MYMAILSLOT",     
        0,                                  
        MAILSLOT_WAIT_FOREVER,
        NULL
    );
    if (hSlots == INVALID_HANDLE_VALUE) { cout << "CreateMailslot Failed with Error # " << GetLastError() << endl; }
    else { cout << "CreateMailslot Success." << endl; }

    
    //ReadFile
    bReadFile = ReadFile(
        hSlots,
        szReadBuffer,
        dwReadFileBufferSize,
        &dwNoBytesRead,
        NULL
    );
    if (bReadFile == FALSE) { cout << "ReadFile Failed with Error # " << GetLastError() << endl; }
    else { cout << "ReadFile Success." << endl; }

    //Convert char[] -> vector<int>
    vector<int> data(100);
    for (int i = 0; i < data.size(); i++)
    {
        data[i] = szReadBuffer[i];
    }

    cout << "\t\t-----MAILSLOTS SERVER-----" << endl;

    //Consume
    Consumer(data);

    CloseHandle(hSlots);
    return 0;
}

void Consumer(vector<int> data)
{
    string file = "C:\\Users\\reigl\\OneDrive\\Documents\\Academia\\Courses\\CEG4350\\FinalSolutions\\MAILBOXES\\Consumer.txt";
    newfile(file); //Create file for saving data
    write(file, data); //Save and Print data
}
int write(string path, vector<int> data)
{
    newfile(path);
    fstream file;
    file.open(path);

    int idx = 0;
    int sz = data.size();
    cout << "Consumer Data: " << endl;
    while (idx < sz)
    {
        cout << data[idx] << " ";
        file << data[idx] << endl;
        idx++;
    }cout << endl;
    file.close();

    return 0;
}
void newfile(string path)
{
    ofstream a;
    a.open(path);
    a.close();
}