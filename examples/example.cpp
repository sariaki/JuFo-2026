int foo() 
{
	volatile int x = 0;
	return x;
}

int bar() 
{
	volatile int x = 1;
	return x;
}

int main() 
{
	volatile int x = foo();
	x = bar();
	//std::cout << "hi" << x;
}