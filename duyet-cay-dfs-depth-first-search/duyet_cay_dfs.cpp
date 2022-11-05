#include<bits/stdc++.h>
#include<fstream>
using namespace std;

// Input
//9 10
//1 2
//1 3
//1 5
//2 4
//3 6
//3 7
//3 9
//5 8
//6 7
//8 9
//9 3

int n, m;
vector<int> adj[1001];
bool visited[1001];

void inpFromFile() {
	ifstream input("data_input.txt");
	fstream output;
	output.open("test.txt", ios::out);
	
	string line;
	while(!input.eof()) {
		getline(input, line);
		output << line;
	}
	
	string str;
	input >> str;
	cout << str;
	output << "Hello world";
	input.close();
	output.close();
}

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

int main() {
//	inpFromFile();
	inp();
	dfs(1);
}
