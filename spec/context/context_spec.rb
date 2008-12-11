require 'ronin/context'

require 'spec_helper'

describe Context do
  before(:all) do
    require 'context/helpers/book_context'
    require 'context/helpers/book_review_context'

    @contexts_dir = File.expand_path(File.join(File.dirname(__FILE__),'helpers','contexts'))
    @snow_crash_path = File.join(@contexts_dir,'snow_crash.rb')
    @neuromancer_path = File.join(@contexts_dir,'neuromancer_review.rb')
  end

  it "should contain defined contexts" do
    Context.is_context?(:book).should == true
  end

  it "should create a class-level context name" do
    Book.context_name.should == :book
  end

  it "should raise an UnknownContext exception when loading unknwon-contexts" do
    lambda {
      Context.load_context(:nothing, 'some_path.rb')
    }.should raise_error(UnknownContext)
  end

  it "should raise a ContextNotFound exception when loading from non-existant files" do
    lambda {
      Context.load_context(:book, 'not_here.rb')
    }.should raise_error(ContextNotFound)
  end

  it "should load contexts by context-name from a file" do
    @book = Context.load_context(:book, @snow_crash_path)
    @book.should_not be_nil
    @book.class.should == Book
  end

  it "should load a specific context from a file with multiple contexts" do
    @book = Context.load_context(:book, @neuromancer_path)
    @book.should_not be_nil
    @book.class.should == Book

    @review = Context.load_context(:book_review, @neuromancer_path)
    @review.should_not be_nil
    @review.class.should == BookReview
  end

  it "should provide class-level methods for loading a context" do
    @book = Book.load_context(@snow_crash_path)
    @book.should_not be_nil
    @book.class.should == Book
  end

  it "should provide top-level ronin methods for loading a context" do
    @book = ronin_load_book(@snow_crash_path)
    @book.should_not be_nil
    @book.class.should == Book
  end

  describe "loaded contexts" do
    before(:all) do
      @book = Book.load_context(@snow_crash_path)
    end

    it "should have a context name" do
      @book.context_name.should == :book
    end

    it "should have attributes" do
      @book.title.should == 'Snow Crash'
      @book.author.should == 'Neal Stephenson'
    end

    it "should have instance methods" do
      @book.methods.include?('rating').should == true
      @book.rating.should == 10
    end
  end
end
