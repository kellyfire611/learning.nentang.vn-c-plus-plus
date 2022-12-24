#include<bits/stdc++.h>
#include<iostream>
using namespace std;
using ll = long long;

const int maxN = 1001;
const int INF = 1e9; // so vo cung
const int NULL_INT = -1;

int n, m; // n: so dinh, m: so canh
int s, t; // s: dinh bat dau, t: dinh ket thuc
vector<pair<int, int>> adj[maxN];

int parent[maxN];
int RC[maxN][maxN]; // luu tru cung xuoi, cung nguoc
int add_flow; // luu tru gia tri luong cuc dai


void inp() {
	cin >> n >> m;
	for(int i = 0; i < m; i++) {
		int x, y, z;
		cin >> x >> y >> z;
		adj[x].push_back({y, z});
		
		// Do thi co huong thi comment dong code sau
		adj[y].push_back({x, z});
		
		// Luu tru gia tri trong so
		RC[x][y] = z;
	}
}

bool bfs(int s, int t, int n) {
	// Khoi tao
	memset(parent, NULL_INT, sizeof(parent));
	parent[s] = 0;
	add_flow = INT_MAX;
	
	queue<int> q;
	q.push(s);
	
	// Lap
	while(!q.empty()) {
		int u = q.front(); // Lay phan tu o dau hang doi
		q.pop(); // xoa bo phan tu o dau ra khoi hang doi
		//cout << v << " ";
		for(auto item: adj[u]) {
			int v = item.first;  // dinh v
			int w = item.second; // trong so
			if(parent[v] == NULL_INT && RC[u][v]) {
				parent[v] = u; // Ghi nhan cha cua v la u
				add_flow = min(add_flow, RC[u][v]);
				
				if(v == t) { // neu lap den dinh ket thuc thi dung vong lap
					return true;
				}
				
				q.push(v);
			}
		}
	}
	return false;
}

// Giai thuat Edmonds_Karp
// s: dinh bat dau
// t: dinh ket thuc
// n: so luong dinh
int maxFlow_Edmonds_Karp(int s, int t, int n) {
	int flow = 0;
	while(bfs(s, t, n)) {
		flow += add_flow;
		int v = t;
		while(v != s) {
			int u = parent[v];
			RC[v][u] += add_flow; // cung nguoc
			RC[u][v] -= add_flow; // cung xuoi
			v = u;
		}
	}
	return flow;
}

int main() {
	// Chuyen NHAP, XUAT thanh file
	freopen("lab_8_1_input.INP", "r", stdin);
	freopen("lab_8_1_output.OUT", "w", stdout);

	// INPUT
	inp();
	
	// OUTPUT
	int s = 1;
	int t = n;
	cout << maxFlow_Edmonds_Karp(s, t, n);
	return 0;
}
