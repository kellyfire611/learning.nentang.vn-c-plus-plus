#include<bits/stdc++.h>
#include<iostream>
using namespace std;
using ll = long long;

const int maxN = 100001;
const int INF = 1e9; // so vo cung

int n, m; // n: so dinh, m: so canh
int s; // dinh bat dau
int t; // dinh ket thuc
vector<pair<int, int>> adj[maxN]; // vector luu tru canh co trong so
int parent[maxN]; // mang dung de tracking duong di

void inp() {
	cin >> n >> m >> s >> t;
	for(int i = 0; i < m; i++) {
		int x, y, w; // canh x -> y co trong so w
		cin >> x >> y >> w;
		adj[x].push_back({y, w});
		
		// Do thi co huong thi comment dong code sau
		//adj[y].push_back({x, w});
	}
}

void dijkstra(int s, int t) {
	// Mang luu khoang cach duong di
	vector<ll> d(n+1, INF);
	d[s] = 0;
	parent[s] = s;
	
	// Hang doi uu tien
	// {khoang_cach, dinh}
	priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> Q;
	Q.push({0, s}); // Khoi tao
	while(!Q.empty()) {
		// Chon ra dinh co khoang cach tu s nho nhat
		pair<int, int> top = Q.top();
		Q.pop();
		
		int u = top.second;
		int kc = top.first;
		if(kc > d[u])
			continue;
			
		// Relaxation: cap nhat khoang cach tu s cho toi moi dinh ke voi u
		for(auto it: adj[u]) {
			int v = it.first;
			int w = it.second;
			if(d[v] > d[u] + w) {
				d[v] = d[u] + w;
				Q.push({d[v], v});
				
				parent[v] = u; // truoc v la u
			}
		}
	}
	
	cout << d[t] << endl;
	vector<int> path;
	while(1) {
		path.push_back(t);
		if(t == s)
			break;
		
		t = parent[t];
	}
	reverse(begin(path), end(path));
	for(int x: path) {
		cout << x << " ";
	}
}

int main() {
	// Chuyen NHAP, XUAT thanh file
	freopen("lab_5_1_input.INP", "r", stdin);
	freopen("lab_5_1_output.OUT", "w", stdout);

	// INPUT
	inp();
	
	// OUTPUT
	dijkstra(s, t);
}
