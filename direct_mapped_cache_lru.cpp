#include <iostream>
#include <cstdlib>
#include <stdio.h>
#include <math.h>

using namespace std;

struct cache_content{
	bool v;
	unsigned int  tag;
	int r;
//	unsigned int	data[16];
};

const int K=1024;

double log2( double n )
{
    // log(n)/log(2) is log2.
    return log( n ) / log(double(2));
}


void simulate(int cache_size, int block_size , int n){
	unsigned int tag,index,x;

	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size/(block_size*n));
	int line= (cache_size>>(offset_bit))/n;
	cache_content **cache = new cache_content *[line];
	for(int i = 0 ; i < line ; i++)
		cache[i] = new cache_content[n];

	//cout<<"cache line:"<<line<<endl;

	for(int j=0;j<line;j++)
		for(int i = 0 ; i < n ;i++)
			{
				cache[j][i].r=0;
				cache[j][i].v=false;
			}

  FILE * fp=fopen("RADIX.txt","r");					//read file

  	//created by me
  	double miss_rate = 0;
  	double hit = 0;
  	double miss = 0;
  	int tmp= line-1;
	while(fscanf(fp,"%x",&x)!=EOF)
	{
		index=(x>>offset_bit)&tmp;
		tag=x>>(index_bit+offset_bit);
		bool check_hit = false;
		for(int i = 0 ; i < n ;i++)
		{
			if(cache[index][i].v && cache[index][i].tag==tag)
			{
				cache[index][i].v=true;
				cache[index][i].r=n;
				hit++; 			//hit
				check_hit = true;
			}
			else
            {
                 //if(cache[index][i].r>0)
                    cache[index][i].r--;
			}
		}
		if(check_hit == true);
		else
		{
		    miss++;
			//check whether the set is full
			bool full = true;
			int subindex;
			for(int i = 0 ; i < n ;i++)
			{
				if(cache[index][i].v==false)
				{
					full = false;
					subindex = i;
					break;
				}
			}
			if(full)
			{	/*
				for(int i =0 ; i < n ;i++)
                {
                   if(cache[index][i].r>0)
                   {
                       cache[index][i].r--;
                   }
                }
				*/
				int victim = 0;
				for(int j =0 ; j < n ; j++)
				{
					//if(cache[index][j].r==0)
						//victim = j;
					if(cache[index][j].r < cache[index][victim].r)victim = j;
				}
				cache[index][victim].v=true;			//miss
				cache[index][victim].tag=tag;
				cache[index][victim].r = n;
			}
			else
			{
				for(int i =0 ; i < n ;i++)
				{
				    if(cache[index][i].r>0)
                    {
                        cache[index][i].r--;
                    }
				}
				cache[index][subindex].v = true;
				cache[index][subindex].tag=tag;
				cache[index][subindex].r = n;
			}
		}
	}
	fclose(fp);
	miss_rate = miss / (hit + miss);
	/*cout<<"miss" << miss<<endl;
	cout<<"hit" << hit<<endl;*/
	cout<<miss_rate<<"\t";
	delete  [] cache;
}

int main(){
	// Let us simulate 4KB cache with 16B blocks in n-way associative set
	cout<<"   \t1-way\t\t2-way\t\t4-way\t\t8-way\n";
	cout<<"1KB\t";
	simulate(1*K, 64 , 1);
	simulate(1*K, 64 , 2);
	simulate(1*K, 64 , 4);
	simulate(1*K, 64 , 8);

	cout<<"\n2KB\t";
	simulate(2*K, 64 , 1);
	simulate(2*K, 64 , 2);
	simulate(2*K, 64 , 4);
	simulate(2*K, 64 , 8);

	cout<<"\n4KB\t";
	simulate(4*K, 64 , 1);
	simulate(4*K, 64 , 2);
	simulate(4*K, 64 , 4);
	simulate(4*K, 64 , 8);

	cout<<"\n8KB\t";
	simulate(8*K, 64 , 1);
	simulate(8*K, 64 , 2);
	simulate(8*K, 64 , 4);
	simulate(8*K, 64 , 8);

	cout<<"\n16KB\t";
	simulate(16*K, 64 , 1);
	simulate(16*K, 64 , 2);
	simulate(16*K, 64 , 4);
	simulate(16*K, 64 , 8);

	cout<<"\n32KB\t";
	simulate(32*K, 64 , 1);
	simulate(32*K, 64 , 2);
	simulate(32*K, 64 , 4);
	simulate(32*K, 64 , 8);

	cout<<endl;
	return 0;

}
