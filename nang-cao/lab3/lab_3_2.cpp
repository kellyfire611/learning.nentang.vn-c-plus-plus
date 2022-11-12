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

void bfs(int u) {
	// Khoi tao
	queue<int> q;
	q.push(u);
	visited[u] = true;
	
	// Lap
	while(!q.empty()) {
		int v = q.front(); // Lay phan tu o dau hang doi
		q.pop(); // xoa bo phan tu o dau ra khoi hang doi
		cout << v << " ";
		for(int x: adj[v]) {
			if(!visited[x]) {
				q.push(x);
				visited[x] = true;
				parent[x] = v; // Ghi nhan cha cua x la v
			}
		}
	}
}

void path(int s, int t) {
	memset(visited, false, sizeof(visited));
	memset(parent, 0, sizeof(parent));
	
	cout << "BFS: ";
	bfs(s);
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
	freopen("lab_3_2_input.INP", "r", stdin);
	freopen("lab_3_2_output.OUT", "w", stdout);

	// INPUT
	inp();
	
	// Duong di tu dinh s -> dinh t
	path(s, t);
}
