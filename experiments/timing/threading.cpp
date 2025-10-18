#include <iostream>
#include <thread>

void thread(int param)
{
    for (int i = 0; i < param; i++)
    {
        asm("nop");
    }
}

int main(int argc, char** argv)
{
    for (int i = 0; i < argc; i++)
    {
        std::thread(thread, 5);
    }
}