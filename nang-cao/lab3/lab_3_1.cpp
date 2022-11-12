#include<bits/stdc++.h>
#include<iostream>
using namespace std;

int n, m;
vector<int> adj[1001];
bool visited[1001];

void inp() {
	cin >> n >> m;
	for(int i = 0; i < m; i++) {
		int x, y;
		cin >> x >> y;
		adj[x].push_back(y);
		
		// Do thi co huong thi comment dong code sau
		adj[y].push_back(x);
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
			}
		}
	}
}

int main() {
	// Chuyen NHAP, XUAT thanh file
	freopen("lab_3_1_input.INP", "r", stdin);
	freopen("lab_3_1_output.OUT", "w", stdout);

	// INPUT
	inp();
	
	// OUTPUT: duyet DFS
	bfs(1);
}
