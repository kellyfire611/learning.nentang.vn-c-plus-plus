#include<bits/stdc++.h>
#include<iostream>
using namespace std;

int n, m; // n: so dinh, m: so canh
vector<int> adj[1001];
bool visited[1001];
int parent[1001];

void inp() {
	cin >> n >> m;
	for(int i = 0; i < m; i++) {
		int x, y;
		cin >> x >> y;
		adj[x].push_back(y);
		
		// Do thi co huong thi comment dong code sau
		adj[y].push_back(x);
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
			dfs(v);
		}
	}
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

void connected_component() {
	int cnt = 0; // Khoi tao so thanh phan lien thong ban dau cua do thi = 0
	
	// Duyet qua cac dinh
	for(int i = 1; i <= n; i++) {
		if(!visited[i]) {
			++cnt; // Tang so thanh phan lien thong
			bfs(i);
			cout << endl;
		}
	}
	
	cout << "Tong so thanh phan lien thong: " << cnt;
}

int main() {
	// Chuyen NHAP, XUAT thanh file
	freopen("lab_4_input.INP", "r", stdin);
	freopen("lab_4_output.OUT", "w", stdout);

	// INPUT
	inp();
	
	// OUTPUT: liet ke cac thanh phan lien thong bang DFS / BFS
	connected_component();
}
