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

  def delete value

  end

  def find value
    
  end

  def level_order

  end

  def preorder

  end

  def inorder

  end

  def postorder

  end

  def height node

  end

  def depth node

  end

  def balanced? tree

  end

  def balance tree

  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new([1, 2, 3, 4, 5, 6, 7])
tree.insert 8

tree.pretty_print