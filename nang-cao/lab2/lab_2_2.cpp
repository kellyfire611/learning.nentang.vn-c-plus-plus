#include<bits/stdc++.h>
#include<iostream>
using namespace std;

int n, m; // n: so dinh, m: so canh
int s, t; // s: dinh bat dau, t: dinh ket thuc
vector<int> adj[1001];
bool visited[1001];
int parent[1001];

void inp() {
	cin >> n >> m >> s >> t;
	for(int i = 0; i < m; i++) {
		int x, y;
		cin >> x >> y;
		adj[x].push_back(y);
		
		// Do thi co huong thi comment dong code sau
		// adj[y].push_back(x);
	}
	
	// Sap xep cac gia tri trong vector tang dan A-Z
	for(int i = 1; i <= n; i++) {
		sort(adj[i].begin(), adj[i].end());
	}
	
	memset(visited, false, sizeof(visited));
}

void dfs(int u) {
	cout << u << " ";
	// Danh dau la u da duoc ghe tham
	visited[u] = true;
	for(int v: adj[u]) {
		// Neu dinh v chua duoc tham
		if(!visited[v]) {
			parent[v] = u; // Ghi nhan cha cua v la u
			dfs(v);
		}
	}
}

void path(int s, int t) {
	memset(visited, false, sizeof(visited));
	memset(parent, 0, sizeof(parent));
	cout << "DFS: ";
	dfs(s);
	cout << endl;
	
	cout << "Path: ";
	if(!visited[t]) {
		cout << "Khong co duong di tu " << s << " den " << t;
	}
	else {
		// Truy vet duong di
		vector<int> path;
		// Bat dau di nguoc tu dinh t
		while(t != s) {
			path.push_back(t);
			t = parent[t]; // Lan nguoc lai
		}
		path.push_back(s);
		reverse(path.begin(), path.end());
		
		// In duong di
		for(int x: path) {
			cout << x << " ";
		}
	}
}

int main() {
	// Chuyen NHAP, XUAT thanh file
	freopen("lab_2_2_input.INP", "r", stdin);
	freopen("lab_2_2_output.OUT", "w", stdout);

	// INPUT
	inp();
	
	// Duong di tu dinh s -> dinh t
	path(s, t);
}
