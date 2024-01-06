# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/stack'

class StackTest < Minitest::Test
  # BEGIN
  def test_add_element_to_stack
    stack = Stack.new
    stack.push!(5)
    assert_equal 1, stack.size
    top_element = stack.instance_variable_get(:@elements)[-1]
    assert_equal 5, top_element
  end

  def test_remove_element_to_stack
    stack = Stack.new
    stack.push!(5)
    get_size = stack.size
    remove_element = stack.pop!
    assert_equal get_size - 1, stack.size
    assert_equal 5, remove_element
  end

  def test_clear_stack
    stack = Stack.new
    stack.push!(5)
    stack.push!(10)
    stack.clear!
    assert_equal 0, stack.size
  end

  def test_emty_stack
    assert_empty []
  end

  # END
end

test_methods = StackTest.new({}).methods.select { |method| method.start_with? 'test_' }
raise 'StackTest has not tests!' if test_methods.empty?
