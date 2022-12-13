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
const int INF = 1e9; // so vo cung

int n, m; // n: so dinh, m: so canh
int parent[maxN], sz[maxN];
vector<edge> canh;

void make_set() {
	for(int i = 1; i <= n; i++) {
		parent[i] = i;
		sz[i] = 1;
	}
}

int find (int v) {
	if(v == parent[v]) {
		return v;
	}
	
	return parent[v] = find(parent[v]);
}

bool Union(int a, int b) {
	a = find(a);
	b = find(b);
	if(a == b) {
		return false; // khong the gop a, b voi nhau
	}
	if(sz[a] < sz[b]) {
		swap(a, b);
	}
	parent[b] = a;
	sz[a] + sz[b];
	return true;
}

void inp() {
	cin >> n >> m;
	for(int i=0; i<m; i++) {
		int x, y, w;
		cin >> x >> y >> w;
		edge e;
		e.u = x;
		e.v = y;
		e.w = w;
		canh.push_back(e);
	}
}

bool cmp(edge a, edge b) {
	return a.w < b.w;
}

void kruskal() {
	// Tao cay khung cuc tieu rong
	vector<edge> mst;
	int d = 0;
	
	// Sort danh sach canh theo chieu dai tang dan
	sort(canh.begin(), canh.end(), cmp);
	
	// Lap qua cac canh
	for(int i=0; i<m; i++) {
		if(mst.size() == n-1) {
			break;
		}
		
		edge e = canh[i]; // chon canh e la canh nho nhat
		if(Union(e.u, e.v)) {
			mst.push_back(e);
			d += e.w;
		}
	}
	
	// Tra ve ket qua
	if(mst.size() != n-1) {
		cout << "Do thi khong lien thong !\n"; // Do thi khong co cay khung
	} else {
		cout << "MST: " << d << endl;
		for(auto it: mst) {
			cout << it.u << " " << it.v << " " << it.w << endl;
		}
	}
}

int main() {
	// Chuyen NHAP, XUAT thanh file
	freopen("lab_6_input.INP", "r", stdin);
	freopen("lab_6_output.OUT", "w", stdout);

	// INPUT
	inp();
	make_set();
	
	// OUTPUT
	kruskal();
}
