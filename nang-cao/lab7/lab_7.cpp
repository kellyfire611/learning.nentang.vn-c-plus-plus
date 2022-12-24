#include<bits/stdc++.h>
#include<iostream>
using namespace std;
using ll = long long;

const int maxN = 100001;
const int INF = 1e9; // so vo cung

int n, m; // n: so dinh, m: so canh
set<int> adj[maxN]; // tap hop luu dinh ke
int degree[maxN]; // bac cua dinh

void inp() {
	cin >> n >> m;
	for(int i=0; i<m; i++) {
		int x, y;
		cin >> x >> y;
		adj[x].insert(y);
		adj[y].insert(x);
		degree[x]++;
		degree[y]++;
	}
}

void euler(int v) {
	stack<int> st;
	vector<int> EC; // Chu trinh Euler
	st.push(v);
	while(!st.empty()) {
		int x = st.top();
		if(adj[x].size() != 0) {
			int y = *adj[x].begin();
			st.push(y);
			//xoa(x,y)
			adj[x].erase(y);
			adj[y].erase(x);
		}
		else {
			st.pop();
			EC.push_back(x);
		}
	}
	reverse(begin(EC), end(EC));
	for(int x: EC) {
		cout << x << ' ';
	}
}

int main() {
	// Chuyen NHAP, XUAT thanh file
	freopen("lab_7_input.INP", "r", stdin);
	freopen("lab_7_output.OUT", "w", stdout);

	// INPUT
	inp();
	
	// OUTPUT
	euler(1);
}
