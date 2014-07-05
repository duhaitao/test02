gridtest: GT4CSCRFC2.cpp  GT4CSCRFC2.h  main.cpp
	g++ -o $@ GT4CSCRFC2.cpp main.cpp -I. -lpthread

clean:
	rm -f gridtest
