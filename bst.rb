class Node
  attr_accessor :data, :left, :right
  def initialize data
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root
  def initialize array
    array.uniq!
    array.sort!
    @root = self.build_tree(array)
  end

  def build_tree array, start = 0, finish = array.length - 1
    return nil if start > finish
    
    mid = (start + finish) / 2
    root = Node.new(array[mid])

    root.left = self.build_tree(array, start, mid - 1)
    root.right = self.build_tree(array, mid + 1, finish)

    return root
  end

  def insert value, node = self.root

    if node == nil
      return Node.new(value)
    end
    if value < node.data
      node.left = self.insert(value, node.left)
    elsif value > node.data
      node.right = self.insert(value, node.right)
    end

    return node
  end

  def find_successor sub_root
    successor = sub_root

    while successor.left != nil
      successor_branch = successor
      successor = successor.left
    end

    if successor_branch
      # connect subroot node to children of successor node if nay exist
      successor_branch.left = successor.right
      successor_branch.left.left = successor.left if successor.left
    end
    
    return successor
  end

  def delete value, node = self.root
    return nil if node == nil
    if node.data == value
    # node has two children
      if node.left && node.right
      # find inorder successor
      sub_root_right = node.right
      sub_root_left = node.left

      successor = self.find_successor(sub_root_right)

      puts "sub-root-right: #{sub_root_right.data} sub-root-left: #{sub_root_left.data} successor: #{successor.data} node: #{node.data}"

      # reassign successor node connections to left and right subtrees
      successor.left = sub_root_left unless successor == sub_root_left
      successor.right = sub_root_right unless successor == sub_root_right
      # reassign Tree instance's root variable to sucessor if it replaced the root node
      self.root = successor if node == self.root

      return successor
    # node has one child
      elsif node.left
        return node.left
      elsif node.right
        return node.right
      else
    # node is leaf
        return nil
      end
    end

    node.left = self.delete(value, node.left)
    node.right = self.delete(value, node.right)

    return node
  end

  def find value, node = self.root
    return nil if node == nil

    if value == node.data
      return node
    elsif value < node.data
      self.find(value, node.left)
    else
      self.find(value, node.right)
    end
  end

  def level_order node = self.root
    results = []
    queue = []
    queue.push node
    while queue.length > 0 
      current = queue.shift
      results << current.data
      queue.push current.left unless current.left == nil
      queue.push current.right unless current.right == nil
    end
    return results
  end

  def recursive_level_order node = self.root, queue = [], results = []
    return if node == nil
    results << node.data
    queue.push node.left unless node.left == nil
    queue.push node.right unless node.right == nil
    self.recursive_level_order(queue.shift, queue, results)
    return results
  end

  def preorder node = self.root, results = []
    return if node == nil
    results << node.data
    self.preorder node.left, results
    self.preorder node.right, results
    return results
  end

  def inorder node = self.root, results = []
    return if node == nil
    self.inorder node.left, results
    results << node.data
    self.inorder node.right, results
    return results
  end

  def postorder node = self.root, results = []
    return if node == nil
    self.postorder node.left, results
    self.postorder node.right, results
    results << node.data
    return results
  end

  def height node, height = 0, results = []
    if node == nil
      # add height count to results array when leaf is reached
      results << height
      return height
    end
    # count each node visited via preorder traversal
    height += 1
    self.height node.left, height, results
    self.height node.right, height, results
    # subtract one from largest height count so result reflects number of connections, not nodes 
    return results.max - 1
  end

  def height_of_value value
    node = self.find value
    self.height node
  end

  def depth node, root = self.root, depth = 0
    return depth if node.data == root.data 
    depth += 1
    return self.depth(node, root.left, depth) if node.data < root.data
    return self.depth(node, root.right, depth) if node.data > root.data
  end

  def depth_of_value value
    node = self.find value
    self.depth node
  end

  def balanced? node = self.root
    # balanced tree: difference between heights of left subtree and right subtree of every node is not more than 1

    return if node == nil
    
    # check height of left subtree
    left_height = self.height(node.left)
    #check height of right subtree
    right_height = self.height(node.right)
    # compare heights
    difference = left_height - right_height
    if difference.abs > 1
      return false
    else 
      self.balanced?(node.left)
      self.balanced?(node.right)
    end
    return true
  end

  def balance 
    array = self.level_order
    self.root = self.build_tree array
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

array = Array.new(15) {rand(1..100)}
tree = Tree.new array
tree.pretty_print
p tree.balanced?
p tree.preorder
p tree.inorder
p tree.postorder
tree.insert rand(100..200)
tree.insert rand(100..200)
tree.insert rand(100..200)
tree.insert rand(100..200)
tree.insert rand(100..200)
tree.pretty_print
p tree.balanced?
tree.balance 
tree.pretty_print
p tree.balanced?
p tree.preorder
p tree.inorder
p tree.postorder