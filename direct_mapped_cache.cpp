#include <iostream>
#include <stdio.h>
#include <math.h>

using namespace std;

struct cache_content{
	bool v;
	unsigned int  tag;
//	unsigned int	data[16];
};

const int K=1024;

double log2( double n )
{
    // log(n)/log(2) is log2.
    return log( n ) / log(double(2));
}


void simulate(int cache_size, int block_size){
	unsigned int tag,index,x;

	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size/block_size);
	int line= cache_size>>(offset_bit);

	cache_content *cache =new cache_content[line];
	//cout<<"cache line:"<<line<<endl;

    double miss_rate = 0;
    double miss = 0;
    double hit = 0;

	for(int j=0;j<line;j++)
		cache[j].v=false;

  FILE * fp=fopen("ICACHE.txt","r");					//read file

	while(fscanf(fp,"%x",&x)!=EOF){
		//cout<<hex<<x<<" ";
		index=(x>>offset_bit)&(line-1);
		tag=x>>(index_bit+offset_bit);
		if(cache[index].v && cache[index].tag==tag){
			cache[index].v=true;
			hit++; 			//hit
		}
		else{
			cache[index].v=true;			//miss
			cache[index].tag=tag;
			miss++;
		}
	}
	fclose(fp);
    miss_rate = miss/(miss+hit);
    //cout<<"miss rate is"<<miss_rate<<endl;
    cout<<miss_rate<<"\t";
	delete [] cache;
}

int main(){
	// Let us simulate 4KB cache with 16B blocks
	cout<<"   \t16\t\t32\t\t64\t\t128\t\t256"<<endl;
	cout<<"4KB\t";
	simulate(4*K, 16);
	simulate(4*K, 32);
	simulate(4*K, 64);
	simulate(4*K, 128);
	simulate(4*K, 256);

	cout<<endl<<"16KB\t";
	simulate(16*K, 16);
	simulate(16*K, 32);
	simulate(16*K, 64);
	simulate(16*K, 128);
	simulate(16*K, 256);

	cout<<endl<<"64KB\t";
	simulate(64*K, 16);
	simulate(64*K, 32);
	simulate(64*K, 64);
	simulate(64*K, 128);
	simulate(64*K, 256);

	cout<<endl<<"256KB\t";
	simulate(256*K, 16);
	simulate(256*K, 32);
	simulate(256*K, 64);
	simulate(256*K, 128);
	simulate(256*K, 256);
	cout<<endl;
	return 0;
}
