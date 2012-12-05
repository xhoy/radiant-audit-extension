require File.dirname(__FILE__) + '/../spec_helper'

describe AuditObserver do
  dataset :users, :pages_with_layouts, :snippets, :archive_pages, :archive_pages , :archive_day_index_pages, :archive_index_tags_and_methods, :archive_year_index_pages

  before(:each) do
    @user = users(:existing)
    AuditObserver.current_user = @user
  end

  describe "Page logging" do
    it "should log create" do
      lambda {
        page = Page.create(:title => 'title', :slug => 'slug', :breadcrumb => 'breadcrumb')
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log update" do
      lambda {
        pages(:home).save
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log destroy" do
      page = Page.create(:title => 'title', :slug => 'slug', :breadcrumb => 'breadcrumb')
      lambda {
        page.destroy
      }.should change(AuditEvent, :count).by(1)
    end
  end

  describe "User logging" do
    it "should log create" do
      lambda {
        User.create!(user_params)
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log update" do
      lambda {
        users(:existing).save
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log destroy" do
      lambda {
        users(:existing).destroy
      }.should change(AuditEvent, :count).by(1)
    end
  end

  describe "Layout logging" do
    it "should log create" do
      lambda {
        Layout.create!(layout_params)
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log update" do
      lambda {
        layouts(:main).save
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log destroy" do
      lambda {
        layouts(:main).destroy
      }.should change(AuditEvent, :count).by(1)
    end
  end

  describe "Snippet logging" do
    it "should log create" do
      lambda {
        Snippet.create!(snippet_params)
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log update" do
      lambda {
        snippets(:first).save
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log destroy" do
      lambda {
        snippets(:first).destroy
      }.should change(AuditEvent, :count).by(1)
    end
  end
  describe "ArchivePage logging" do
    it "should log create" do
      lambda {
        ArchivePage.create!(archivepage_params)
      }.should change(AuditEvent, :count).by(1)
    end

    it "should log update" do
      lambda {
        archivepages(:first).save
      }.should change(AuditEvent, :count).by(1)
    end

    it "should log destroy" do
      lambda {
        archivepages(:first).destroy
      }.should change(AuditEvent, :count).by(1)
    end
  end
  describe "ArchiveMonthIndexPage logging" do
    it "should log create" do
      lambda {
        ArchiveMonthIndexPage.create!(archivemonthindexpage_params)
      }.should change(AuditEvent, :count).by(1)
    end

    it "should log update" do
      lambda {
        archivemonthindexpages(:first).save
      }.should change(AuditEvent, :count).by(1)
    end

    it "should log destroy" do
      lambda {
        archivemonthindexpages(:first).destroy
      }.should change(AuditEvent, :count).by(1)
    end
  end
  describe "ArchiveDayIndexPage logging" do
    it "should log create" do
      lambda {
        ArchiveDayIndexPage.create!(archivedayindexpage_params)
      }.should change(AuditEvent, :count).by(1)
    end

    it "should log update" do
      lambda {
        archivedayindexpages(:first).save
      }.should change(AuditEvent, :count).by(1)
    end

    it "should log destroy" do
      lambda {
        archivedayindexpages(:first).destroy
      }.should change(AuditEvent, :count).by(1)
    end
  end
  describe "ArchiveYearIndexPage logging" do
    it "should log create" do
      lambda {
        ArchiveYearIndexPage.create!(archiveyearindexpage_params)
      }.should change(AuditEvent, :count).by(1)
    end

    it "should log update" do
      lambda {
        archiveyearindexpages(:first).save
      }.should change(AuditEvent, :count).by(1)
    end

    it "should log destroy" do
      lambda {
        archiveyearindexpages(:first).destroy
      }.should change(AuditEvent, :count).by(1)
    end
  end
  describe "ArchiveIndexTagsAndMethods logging" do
    it "should log create" do
      lambda {
        ArchiveIndexTagsAndMethods.create!(archiveindextagsandmethods_params)
      }.should change(AuditEvent, :count).by(1)
    end

    it "should log update" do
      lambda {
        archiveindextagsandmethods(:first).save
      }.should change(AuditEvent, :count).by(1)
    end

    it "should log destroy" do
      lambda {
        archiveindextagsandmethods(:first).destroy
      }.should change(AuditEvent, :count).by(1)
    end
  end



end
