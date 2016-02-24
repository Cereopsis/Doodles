/*
The MIT License (MIT)

Copyright (c) 2015 Cereopsis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation

enum Node {
    case Leaf(Int)
    indirect case Fork(Node, Node)
    
    /// Return the value of the first leaf
    ///
    /// e.g .Fork(.Leaf(1), .Fork(.Leaf(2), .Leaf(3))) -> 1
    func head() -> Int {
        switch self {
        case .Leaf(let i):
            return i
        case .Fork(let leaf, _):
            return leaf.head()
        }
    }
    
    /// Return the value of the last leaf
    ///
    /// e.g .Fork(.Leaf(1), .Fork(.Leaf(2), .Leaf(3))) -> 3
    func tail() -> Int {
        switch self {
        case .Leaf(let i):
            return i
        case .Fork(_, let fork):
            return fork.tail()
        }
    }
    
    /// Return the set of all integers in this node
    func vertices() -> Set<Int> {
        switch self {
        case .Leaf(let i):
            return Set([i])
        case .Fork(let a, let b):
            return a.vertices().union(b.vertices())
        }
    }
    
    /// Return a count of nodes
    func depth() -> Int {
        switch self {
        case .Leaf(_):
            return 1
        case .Fork(let a, let b):
            return a.depth() + b.depth()
        }
    }

}

class Edge {
    
    let vertex: Int
    var connections: [Int] = []
    
    init(vertex: Int) {
        self.vertex = vertex
    }
    
    /// Connect two vertices. `self` is considered the owner, which makes this a directed graph?
    func addConnection(connection: Int) {
        if connection != vertex && !connections.contains(connection) {
            connections.append(connection)
        }
    }
    
    /// Returns an enumeration of all connected vertices in Node.Fork(.Leaf(_), .Leaf(_)) format
    func connectionsTo(vertices: Set<Int>) -> [Node] {
        return vertices
               .intersect(connections)
               .map{
                    Node.Fork(.Leaf(vertex), .Leaf($0))
               }
    }
    
    /// Returns true if `vertex` is contained in `connections`
    func isConnected(vertex: Int) -> Bool {
        return connections.contains(vertex)
    }
}

class Graph {
    
    let vertices: Range<Int>
    var edges: [Int: Edge] = [:]
    
    init(vertices: Range<Int>) {
        self.vertices = vertices
    }
    
    subscript(key: Int) -> Edge? {
        return edges[key]
    }
    
    /// Create an Edge object for each connected pair
    func connect(src: Int, dest: Int) {
        if vertices.contains(src) && vertices.contains(dest) {
            if let edge = edges[src] {
                edge.addConnection(dest)
            } else {
                let edge = Edge(vertex: src)
                edge.addConnection(dest)
                edges[src] = edge
            }
        }
    }
    
}
