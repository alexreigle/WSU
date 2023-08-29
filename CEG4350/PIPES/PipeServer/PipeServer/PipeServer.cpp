
#pragma once
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <stdlib.h>
#include <time.h>
#include <stdexcept>
#include <Windows.h>

using namespace std;

vector<int> Producer();

void newfile(string);
vector<int> generate(int, int);
void write(string, vector<int>);

int main(int argc, char* argv[])
{
	cout << "\t\t....PRODUCER SERVER...." << endl;

	//Produce the Data
	vector<int> data = Producer();
	char dataChar[1023] = "";
	for (int i = 0; i < data.size(); i++)
	{
		dataChar[i] = ('0' + data[i]);		//Convert data into character values to be printed and transfered across pipe
	}

	//Named Pipe Local Variable
	HANDLE	hCreateNamedPipe;
	char	szInputBuffer[1023];
	char	szOutputBuffer[1023];
	DWORD	dwInputBufferSize = sizeof(szInputBuffer);
	DWORD	dwOutputBufferSize = sizeof(szOutputBuffer);

	//ConnectNamedpipe Local Variable
	BOOL	bConnectNamedPipe;

	//WriteFile Local Variable
	BOOL	bWritefile;
	DWORD	dwWiteBufferSize = sizeof(dataChar);	//Print the data being transfered over the pipe
	DWORD	dwNoBytesWrite;

	//FlushBuffer Local Variables
	BOOL bFlushFileBuffer;

	//ReadFile Local Variable
	BOOL	bReadfile;
	char	szReadFileBuffer[1023];
	DWORD	dwReadBufferSize = sizeof(szReadFileBuffer);
	DWORD	dwNoBytesRead;

	//CreateNamedPipe
	hCreateNamedPipe = CreateNamedPipe(
		L"\\\\.\\pipe\\MYNAMEDPIPE",							//Pipe Name
		PIPE_ACCESS_DUPLEX,										//Defines that we can both read and write at the same time.
		PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE | PIPE_WAIT,	//Pipe Mode 
		PIPE_UNLIMITED_INSTANCES,								//Maximum Instances of Pipe (up to 256 pipe instances)
		dwOutputBufferSize,										//Output Buffer Size
		dwInputBufferSize,										//Input Buffer Size
		0,														//Timeout (Doesn't Time Out)
		NULL													//Security Parameter
	);
	if (hCreateNamedPipe == INVALID_HANDLE_VALUE) { cout << "Server: CreateNamedPipe Failed with Error # " << GetLastError() << endl; }
	//else { cout << "Server: CreateNamedPipe Success." << endl; }

	//ConnectNamedPipe
	bConnectNamedPipe = ConnectNamedPipe(hCreateNamedPipe, NULL);
	if (bConnectNamedPipe == FALSE) { cout << "Server: ConnectNamedPipe Failed with Error # " << GetLastError() << endl; }
	//else { cout << "Server: ConnectNamePipe Success." << endl; }



	//WriteFile Operation
	bWritefile = WriteFile(
		hCreateNamedPipe,
		dataChar,
		dwWiteBufferSize,
		&dwNoBytesWrite,
		NULL
	);
	if (bWritefile == FALSE) { cout << "Server: WriteFile Failed with Error # " << GetLastError() << endl; }
	//else { cout << "Server: WriteFile Success." << endl; }


	//Flush the File Buffer
	bFlushFileBuffer = FlushFileBuffers(hCreateNamedPipe);
	if (bFlushFileBuffer == FALSE) { cout << "Server: FlushFileBuffer Failed with Error # " << GetLastError() << endl; }
	//else { cout << "Server: FlushFileBuffer Success." << endl; }

	
	//ReadFile Operation
	bReadfile = ReadFile(
		hCreateNamedPipe,
		szReadFileBuffer,
		dwReadBufferSize,
		&dwNoBytesRead,
		NULL
	);
	if (bReadfile == FALSE) { cout << "Server: ReadFile Failed with Error # " << GetLastError() << endl; }
	else
	{
		cout << endl << "\t\t....PRODUCER SERVER...." << endl;
		cout << "DATA READING FROM CLIENT -> " << szReadFileBuffer << endl;
	}

	//Disconnect NamedPipe
	DisconnectNamedPipe(hCreateNamedPipe);

	//CloseHandle
	CloseHandle(hCreateNamedPipe);

	return 0;
}

vector<int> Producer()
{
	cout << "Producer Process Entered.\n";

	int size = 100;		// Number of randomly generated integers
	int upLim = 100;	// Upper limit to range of randomly generated integers. 
	string writeLocation = "C:\\Users\\reigl\\OneDrive\\Documents\\Academia\\Courses\\CEG4350\\FinalSolutions\\PIPES";
	string file = writeLocation + "\\ProducerFile.txt"; //File produced, saving the data
	vector<int> data(size);

	newfile(file); //Create a new file to save data 
	data = generate(upLim, size); //Generate size number of random integers between 0 and uplim
	write(file, data); //Print data and Write it to a file

	return data;
}

void newfile(string path1)
{
	ofstream a;
	a.open(path1);
	a.close();
}
vector<int> generate(int lim, int sz)
{
	vector<int> data(sz);

	srand(time(NULL));
	for (int idx = 0; idx < sz; idx++)
	{
		data[idx] = rand() % lim + 1;
	}

	return data;
}
void write(string path, vector<int> data)
{
	fstream file;
	file.open(path);

	int idx = 0;
	int sz = data.size();
	cout << "Data Written to Pipe" << endl;
	while (idx < sz)
	{
		file << data[idx] << endl;
		cout << data[idx] << " ";
		idx++;
	} cout << endl;
	file.close();

}
