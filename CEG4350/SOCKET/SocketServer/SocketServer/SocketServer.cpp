#pragma once
#include <Windows.h>
#include <iostream>
#include <winsock.h>
#include <fstream>
#include <vector>
#include <string>
#include <stdlib.h>
#include <time.h>

using namespace std;

int Consumer(vector<int>);
void newfile(string);
void write(string, vector<int>);

int main()
{
    cout << "\t\t ------UDP SERVER------" << endl << endl;
    
    //Local Variable Definitions
    WSADATA     WinSockData;
    int         iWsaStartup;
    int         iWsaCleanup;

    SOCKET      UDPSocketServer;
    struct      sockaddr_in UDPClient;

    char        Buffer[512];
    int         iBufferLen = strlen(Buffer) + 1;

    int         iBind;
    int         iReceiverFrom;

    int         iUDPClientLen = sizeof(UDPClient);
    int         iCloseSocket;

    //WSAStartUp
    iWsaStartup = WSAStartup(MAKEWORD(2, 2), &WinSockData);
    if (iWsaStartup != 0) { cout << "WSAStartUp function Failed." << endl; }
    //else { cout << "WSAStartup function Success." << endl; }

    //Fill UDPClient(socket address) Struct
    UDPClient.sin_family = AF_INET;
    UDPClient.sin_addr.s_addr = inet_addr("127.0.01");
    UDPClient.sin_port = htons(1025);     //Convert Port Number from Litle Endian to Big Endian

    //Socket Creation
    UDPSocketServer = socket(
        AF_INET,     //Address Family Type (Internet)
        SOCK_DGRAM,  //Type of Socket (Datagram)
        IPPROTO_UDP  //Protocol Name (UDP)
    );
    if (UDPSocketServer == INVALID_SOCKET) { cout << "Socket Creation Failed with Error # " << WSAGetLastError() << endl; }
    //else { cout << "Socket Creation Success." << endl; }

    //Bind server to socket
    iBind = bind(
        UDPSocketServer,        //nameof socket
        (SOCKADDR*)&UDPClient,  //type cast of the address of the socket (since it resides client-side)
        sizeof(UDPClient)
    );
    if (iBind == SOCKET_ERROR) { cout << "Binding Failed with Error # " << WSAGetLastError() << endl; }
    //else { cout << "Binding Success." << endl; }

    //Receive Data from Client
    iReceiverFrom = recvfrom(
        UDPSocketServer,
        Buffer,
        iBufferLen,
        MSG_PEEK,
        (SOCKADDR*)&UDPClient,
        &iUDPClientLen
    );
    if (iReceiverFrom == SOCKET_ERROR) { cout << "Receiving Failed with Error # " << WSAGetLastError() << endl; }
    //else { cout << "Receiving Success." << endl; }

    //Convert Characters to Integer Values (get Data from pipe)
    char bufferMsgAdjusted[512];
    int size = 0;
    for (int i = 0; i < sizeof(Buffer); i++)
    {
        bufferMsgAdjusted[i] = (Buffer[i] - '0');
        if (bufferMsgAdjusted[i] != -48 && bufferMsgAdjusted[i] != -100) { size++; }
    }
    vector<int> data(size);							
    for (int idx = 0; idx < size; idx++)
    {
        data[idx] = (bufferMsgAdjusted[idx]);		

    }												


    //Consume Data
    Consumer(data);

    //closesocket
    iCloseSocket = closesocket(UDPSocketServer);
    if (iCloseSocket == SOCKET_ERROR) { cout << "Close Socket Failed with Error # " << WSAGetLastError() << endl; }
    //else { cout << "Close Socket Success." << endl; }

    //WSACleanUp
    iWsaCleanup = WSACleanup();     //Uses Winsock 2 DLL (Ws2_32.dll)
    if (iWsaCleanup == SOCKET_ERROR) { cout << "WSA CleanUp Failed with Error # " << WSAGetLastError() << endl; }
    //else { cout << "WSA CleanUp Success." << endl; }

    return 0;
}

int Consumer(vector<int> data)
{
    cout << "Consumer Process Entered.\n";

    string writeLocation = "C:\\Users\\reigl\\OneDrive\\Documents\\Academia\\Courses\\CEG4350\\FinalSolutions\\SOCKET";
    string pfile = writeLocation + "\\ProducerFile.txt"; //File read
    string cfile = writeLocation + "\\ConsumerFile.txt"; //File produced


    newfile(cfile); //Open File to save data read from pipe
    write(cfile, data); //Write to file & Print data from pipe

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

    cout << "Data Read From Socket" << endl;
    while (idx < sz)
    {
        file << data[idx] << endl;
        cout << data[idx] << " ";
        idx++;
    } cout << endl;
    file.close();

}
