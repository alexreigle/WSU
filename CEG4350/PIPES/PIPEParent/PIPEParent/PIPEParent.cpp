
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

int CallProducerChild();
int CallConsumerChild();

int main()
{

	CallProducerChild();
	CallConsumerChild();

	return 0;
}

int CallProducerChild()
{
	//Initialize Process
	HANDLE hProcess = NULL;
	HANDLE hThread = NULL;
	STARTUPINFO si;
	PROCESS_INFORMATION pi;
	DWORD dwProcessId = 0;
	DWORD dwThreadId = 0;
	ZeroMemory(&si, sizeof(si));
	ZeroMemory(&pi, sizeof(pi));
	BOOL bCreateProcess = NULL;

	bCreateProcess = CreateProcess(
		L"C:\\Users\\reigl\\OneDrive\\Documents\\Academia\\Courses\\CEG4350\\FinalSolutions\\PIPEs\\PipeServer\\Debug\\PipeServer.exe", //App Name
		NULL, // Command Line
		NULL, // Process Attribute
		NULL, // Thread Attribute
		FALSE,// Inherit Handle
		0,    // Creation Flag
		NULL, // Environment Variable
		NULL, // Current Directory
		&si,  // Startup Info
		&pi   // Process Info
	);

	if (bCreateProcess == FALSE)
	{
		std::cout << "Producer Process Failed & Error No - " << GetLastError() << std::endl;
	}



	CloseHandle(pi.hProcess);
	CloseHandle(pi.hThread);

	return 0;
}
int CallConsumerChild()
{
	//Initialize Process
	HANDLE hProcess = NULL;
	HANDLE hThread = NULL;
	STARTUPINFO si;
	PROCESS_INFORMATION pi;
	DWORD dwProcessId = 0;
	DWORD dwThreadId = 0;
	ZeroMemory(&si, sizeof(si));
	ZeroMemory(&pi, sizeof(pi));
	BOOL bCreateProcess = NULL;

	bCreateProcess = CreateProcess(
		L"C:\\Users\\reigl\\OneDrive\\Documents\\Academia\\Courses\\CEG4350\\FinalSolutions\\PIPES\\PipeClient\\Debug\\PipeClient.exe", //App Name
		NULL, // Command Line
		NULL, // Process Attribute
		NULL, // Thread Attribute
		FALSE,// Inherit Handle
		0,    // Creation Flag
		NULL, // Environment Variable
		NULL, // Current Directory
		&si,  // Startup Info
		&pi   // Process Info
	);

	if (bCreateProcess == FALSE)
	{
		std::cout << "Consumer Process Failed & Error No - " << GetLastError() << std::endl;
	}



	CloseHandle(pi.hProcess);
	CloseHandle(pi.hThread);

	return 0;
}