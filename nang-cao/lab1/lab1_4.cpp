#include<bits/stdc++.h>
#include <iostream>
using namespace std;

/*
Cho đồ thị vô hướng G=<V,E> được biểu diễn dưới dạng ma trận kề. 
Hãy viết chương trình thực hiện chuyển đổi biểu diễn đồ thị dưới dạng danh sách kề.

Input
Dòng đầu tiên chứa số n là số đỉnh của đồ thị (1 <= n <= 1000)
N dòng tiếp theo, mỗi dòng N số biểu diễn ma trận kề của đồ thị.

Output
In ra danh sách kề tương ứng của đồ thị, liệt kê theo thứ tự tăng dần của các đỉnh
*/

int n, m; //n: dinh, m: canh
int a[1001][1001]; // ma tran ke
vector<int> adj[1001]; // danh sach ke

int main() {
	// Chuyen NHAP, XUAT thanh file
	freopen("lab1_4_input.INP", "r", stdin);
	freopen("lab1_4_output.OUT", "w", stdout);
	
	// INPUT
	cin >> n;
	for(int i = 1; i <= n; i++) {
		for(int j = 1; j <= n; j++) {
			cin >> a[i][j];
		}
	}
	
	// In ra ma tran ke vua lay duoc
//	cout << "Ma tran ke: " << n << " dinh" << endl;
//	for(int i = 1; i <= n; i++) {
//		for(int j = 1; j <= n; j++) {
//			cout << a[i][j] << " ";
//		}
//		cout << endl;
//	}
	
	// Luu vao danh sach ke
	for(int i = 1; i <= n; i++) {
		for(int j = 1; j <= n; j++) {
			if(a[i][j] == 1
				&& i < j)
			{
				adj[i].push_back(j);
				adj[j].push_back(i);
			}
		}
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
