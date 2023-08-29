#pragma once

#include <iostream>
#include <stdio.h>
#include <windows.h>
#include <fstream>
#include <vector>
#include <string>
#include <stdlib.h>
#include <time.h>
#include <stdexcept>

int Producer();
int Consumer();

int main()
{
    Consumer();
    Sleep(1000);
    Producer();
    
    return 0;
}

int Producer()
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
        L"C:\\Users\\reigl\\OneDrive\\Documents\\Academia\\Courses\\CEG4350\\FinalSolutions\\MAILBOXES\\MailslotClient\\Debug\\MailslotClient.exe", //App Name
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
        std::cout << "Create Producer Process Failed & Error No - " << GetLastError() << std::endl;
    }


    WaitForSingleObject(pi.hProcess, INFINITE); //Wait for process to complete and close
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);

    return 0;
}
int Consumer()
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
        L"C:\\Users\\reigl\\OneDrive\\Documents\\Academia\\Courses\\CEG4350\\FinalSolutions\\MAILBOXES\\MailslotServer\\Debug\\MailslotServer.exe", //App Name
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