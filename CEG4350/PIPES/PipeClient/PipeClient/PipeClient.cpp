#pragma once

#include <iostream>
#include <Windows.h>
#include <fstream>
#include <vector>
#include <string>
#include <stdlib.h>
#include <time.h>
#include <stdexcept>

using namespace std;

int Consumer(vector<int>);
void newfile(string);
void write(string, vector<int>);

int main(int argc, char* argv[])
{
	cout << "\n\t\t....CONSUMER CLIENT...." << endl;

	//Local Variables
	HANDLE hCreateFile;

	//ReadFile Local Variables
	BOOL	bReadFile;
	DWORD	dwNoBytesRead;
	char	szReadFileBuffer[1023];
	DWORD	dwReadFileBufferSize = sizeof(szReadFileBuffer);

	//WriteFile Local Variables
	BOOL	bWriteFile;
	DWORD	dwNoBytesWrite;
	char	szWriteFileBuffer[1023] = "Client Consumed Data from Pipe";
	DWORD	dwWriteFileBufferSize = sizeof(szWriteFileBuffer);

	//CreatFile for Pipe
	hCreateFile = CreateFile(
		L"\\\\.\\pipe\\MYNAMEDPIPE",
		GENERIC_READ | GENERIC_WRITE,
		0,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL
	);
	if (hCreateFile == INVALID_HANDLE_VALUE) { cout << "Client: CreateFile Failed with Error # " << GetLastError() << endl; }
	//else { cout << "Client: CreateFile Success" << endl; }

	//ReadFile Operation
	bReadFile = ReadFile(
		hCreateFile,
		szReadFileBuffer,
		dwReadFileBufferSize,
		&dwNoBytesRead,
		NULL
	);
	if (bReadFile == FALSE) { cout << "Client: ReadFile Failed with Error # " << GetLastError() << endl; }
	else
	{
		//cout << "Client: ReadFile Success" << endl;
	}

	//Convert Characters to Integer Values (get Data from pipe)
	char bufferMsgAdjusted[1023];
	int size = 0;
	for (int i = 0; i < sizeof(szReadFileBuffer); i++)
	{
		bufferMsgAdjusted[i] = (szReadFileBuffer[i] - '0');
		if (bufferMsgAdjusted[i] != -48) { size++; }
	}
	//Print Data Read from Pipe
	vector<int> data(size);							cout << "Data Read from Pipe  -> ";
	for (int idx = 0; idx < size; idx++)
	{
		data[idx] = (bufferMsgAdjusted[idx]);		cout << data[idx] << " ";

	}												cout << endl;


	//Consume Data
	Consumer(data);

	//WriteFile Operation
	bWriteFile = WriteFile(
		hCreateFile,
		szWriteFileBuffer,
		dwWriteFileBufferSize,
		&dwNoBytesWrite,
		NULL
	);
	if (bWriteFile == FALSE) { cout << "Client: WriteFile Failed with Error # " << GetLastError() << endl; }
	//else { cout << "Client: WriteFile Success" << endl; }

	//Close Handles
	CloseHandle(hCreateFile);

	return 0;

}

int Consumer(vector<int> data)
{
	cout << "Consumer Process Entered.\n";

	string writeLocation = "C:\\Users\\reigl\\OneDrive\\Documents\\Academia\\Courses\\CEG4350\\FinalSolutions\\PIPES";
	string pfile = writeLocation + "\\ProducerFile.txt"; //File read
	string cfile = writeLocation + "\\ConsumerFile.txt"; //File produced


	newfile(cfile); //Open File to save data read from pipe
	write(cfile, data); //Write data to file from pipe

	return 0;
}

void newfile(string path1)
{
	ofstream a;
	a.open(path1);
	a.close();
}
void write(string path, vector<int> data)
{
	fstream file;
	file.open(path);

	int idx = 0;
	int sz = data.size();
	while (idx < sz)
	{
		file << data[idx] << endl;
		idx++;
	} 
	file.close();

}
