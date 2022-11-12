#include<bits/stdc++.h>
#include <iostream>
using namespace std;

/*
Cho đồ thị vô hướng G=<V,E> được biểu diễn dưới dạng danh sách cạnh. 
Hãy viết chương trình thực hiện chuyển đổi biểu diễn đồ thị dưới dạng danh sách kề.

Input
Dòng đầu tiên chứa 2 số n, m là số đỉnh và số cạnh của đồ thị (1 <= n <= 1000, 1 <= m <= n*(n-1)/2).
M dòng tiếp theo, mỗi dòng là 2 số u, v biểu diễn cạnh u, v của đồ thị (1 <= u, v <= n). Các cạnh được liệt kê theo thứ tự tăng dần của các đỉnh đầu.

Output
In ra danh sách kề tương ứng của đồ thị, liệt kê theo thứ tự tăng dần của các đỉnh
*/

int n, m; //n: dinh, m: canh
vector<int> adj[1001]; // adj[i]: luu danh sach ke cua dinh i

int main() {
	// Chuyen NHAP, XUAT thanh file
	freopen("lab1_2_input.INP", "r", stdin);
	freopen("lab1_2_output.OUT", "w", stdout);
	
	// INPUT
	cin >> n >> m;
	for(int i = 0; i < m; i++) {
		int x, y;
		cin >> x >> y;
		
		adj[x].push_back(y);
		adj[y].push_back(x); // Do thi vo huong
	}
	
	// OUTPUT, danh sach ke
	for(int i = 1; i <= n; i++) {
		cout << i << ": ";
		for(int x: adj[i]) {
			cout << x << " ";
		}
		cout << endl;
	}
}
