#pragma once
#include <Windows.h>
#include <iostream>
#include <vector>
#include <time.h>
#include <fstream>

using namespace std;

vector<int> Producer(int, int);
void newfile(string);
int write(string, vector<int>);

int main()
{
    cout << "\t\t-----MAILSLOTS CLIENT-----" << endl;
    //CreateFile Local Variable
    HANDLE hCreateFile;

    //WriteFile Local Variables
    BOOL    bWriteFile;
    DWORD   dwNoBytesWrite;
    

    //CreateFile
    hCreateFile = CreateFile(
        L"\\\\.\\mailslot\\MYMAILSLOT",
        GENERIC_READ | GENERIC_WRITE,
        0,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL
    );
    if (hCreateFile == INVALID_HANDLE_VALUE) { cout << "CreateFile Failed with Error # " << GetLastError() << endl; }
    else { cout << "CreateFile Success." << endl; }

    //Produce Data
    vector<int> data(100);
    data = Producer(100, 100);
    char    szWriteFileBuffer[1023]; 
    DWORD   dwWriteFileBufferSize = sizeof(szWriteFileBuffer);
    for (int i = 0; i < data.size(); i++)
    {
        szWriteFileBuffer[i] = data[i]; //Write data to message to be placed in mailslot
    }
    string file = "C:\\Users\\reigl\\OneDrive\\Documents\\Academia\\Courses\\CEG4350\\FinalSolutions\\MAILBOXES\\Producer.txt";
    write(file, data); //Save and Print data

    //WriteFile
    bWriteFile = WriteFile(
        hCreateFile,
        szWriteFileBuffer,
        dwWriteFileBufferSize,
        &dwNoBytesWrite,
        NULL
    );
    if (bWriteFile == FALSE) { cout << "WriteFile Failed with Error # " << GetLastError() << endl; }
    else { cout << "WriteFile Success." << endl; }

    CloseHandle(hCreateFile);
    return 0;
}

vector<int> Producer(int sz, int lim)
{
    vector<int> data(100);
    srand(time(NULL));
    for (int idx = 0; idx < sz; idx++)
    {
        data[idx] = rand() % lim + 1;
    }


    return data;
}

int write(string path, vector<int> data)
{
    newfile(path);
    fstream file;
    file.open(path);

    int idx = 0;
    int sz = data.size();
    cout << "Producer Data: " << endl;
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