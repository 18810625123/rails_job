require 'test_helper'

class WorksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @work = works(:one)
  end

  test "should get index" do
    get works_url
    assert_response :success
  end

  test "should get new" do
    get new_work_url
    assert_response :success
  end

  test "should create work" do
    assert_difference('Work.count') do
      post works_url, params: { work: { address: @work.address, checksum: @work.checksum, city: @work.city, company_name: @work.company_name, degree: @work.degree, email: @work.email, end: @work.end, experience: @work.experience, jd: @work.jd, nature: @work.nature, profession: @work.profession, salary: @work.salary, source: @work.source, start: @work.start, title: @work.title, url: @work.url } }
    end

    assert_redirected_to work_url(Work.last)
  end

  test "should show work" do
    get work_url(@work)
    assert_response :success
  end

  test "should get edit" do
    get edit_work_url(@work)
    assert_response :success
  end

  test "should update work" do
    patch work_url(@work), params: { work: { address: @work.address, checksum: @work.checksum, city: @work.city, company_name: @work.company_name, degree: @work.degree, email: @work.email, end: @work.end, experience: @work.experience, jd: @work.jd, nature: @work.nature, profession: @work.profession, salary: @work.salary, source: @work.source, start: @work.start, title: @work.title, url: @work.url } }
    assert_redirected_to work_url(@work)
  end

  test "should destroy work" do
    assert_difference('Work.count', -1) do
      delete work_url(@work)
    end

    assert_redirected_to works_url
  end
end
