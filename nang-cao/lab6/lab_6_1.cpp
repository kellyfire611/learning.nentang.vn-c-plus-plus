#include<bits/stdc++.h>
#include<iostream>
using namespace std;
using ll = long long;

struct edge {
  int u;
  int v;
  int w;
};
const int maxN = 100001;
const int INT_MAX = 1e9;

int n, m; // n: so dinh, m: so canh
vector<pair<int, int>> adj[maxN];
vector<edge> canh;
bool used[maxN]; // used[i]=true: i thuoc tap V(MST)
				 // used[i]=false: i thuoc tap v

void inp() {
  cin >> n >> m;
  for(int i=0; i<m; i++) {
    int x, y, w;
    cin >> x >> y >> w;
    adj[x].push_back({y, w});
    adj[y].push_back({x, w});
  }
  memset(used, false, sizeof(used));
}

void prim(int u) {
	vector<edge> MST; 	// cay khung
	int d = 0; 			// chieu dai cay khung
	used[u] = true;		// dua dinh u vao tap V(MST)
	while(MST.size() < n-1) {
		//e = {x, y}: canh ngan nhat co x thuoc V va y thuoc V(MST)
		int min_w = INT_MAX;
		int X, Y; // luu 2 dinh cua canh e
		for(int i=1; i<= n; i++) {
			// neu dinh i thuoc tap V(MST)
			if(used[i]) {
				// Duyet danh sach ke cua dinh i
				for(auto it: adj[i]) {
					int j = it.first;
					int trongso = it.second;
					if(!used[j] && trongso < min_w) {
						min_w = trongso;
						X = j;
						Y = i;
					}
				}
			}
		}
		MST.push_back({X, Y, min_w});
		d += min_w;
		used[X] = true; // cho dinh X vao V(MST), loai X khoi tap V
	}
	
	cout << d << endl;
	for(edge e: MST) {
		cout << e.u << " " << e.v << " " << endl;
	}
}

int main() {
  // Chuyen NHAP, XUAT thanh file
  freopen("lab_6_1_input.INP", "r", stdin);
  freopen("lab_6_1_output.OUT", "w", stdout);

  // INPUT
  inp();
 
  // OUTPUT
  prim();
}
