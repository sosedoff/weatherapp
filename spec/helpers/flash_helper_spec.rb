require "rails_helper"

RSpec.describe FlashHelper, type: :helper do
  describe "#render_flash_messages" do
    before do
      # Ensure flash is cleared before each test
      flash.clear
    end

    it "returns nil if flash is empty" do
      expect(helper.render_flash_messages).to be_nil
    end

    it "renders a single flash message" do
      flash[:notice] = "Hello world!"
      html = helper.render_flash_messages
      expect(html).to include("alert alert-notice")
      expect(html).to include("Hello world!")
    end

    it "renders multiple flash messages" do
      flash[:notice] = "Notice message"
      flash[:alert] = "Alert message"
      html = helper.render_flash_messages
      expect(html).to include(
        "alert alert-notice",
        "Notice message",
        "alert alert-alert",
        "Alert message"
      )
    end

    it "maps error key to danger class" do
      flash[:error] = "Something went wrong"
      html = helper.render_flash_messages
      expect(html).to include("alert alert-danger")
      expect(html).to include("Something went wrong")
    end

    it "wraps messages in container and text-center classes" do
      flash[:notice] = "Centered message"
      html = helper.render_flash_messages
      expect(html).to include("container text-center")
    end

    it "calls flash.discard after rendering" do
      flash[:notice] = "Message"
      expect(flash).to receive(:discard)
      helper.render_flash_messages
    end
  end
end 
