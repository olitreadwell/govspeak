require "test_helper"

class GovspeakPostProcessorTest < Minitest::Test
  def render_govspeak(govspeak, attachments = [])
    Govspeak::Document.new(govspeak, attachments:).to_html
  end

  # The `Attachment` and `AttachmentLink` govspeak extensions only ever emit a
  # <govspeak-embed-attachment(-link)> element when a matching attachment is
  # found, so the "not found" branch below can't be reached that way. But both
  # elements are explicitly allowlisted by HtmlSanitizer, so they can also
  # reach the post-processor directly as raw HTML in the source document with
  # an id that matches no attachment.
  test "removes a govspeak-embed-attachment element that has no matching attachment" do
    rendered = render_govspeak(%(<govspeak-embed-attachment id="missing"></govspeak-embed-attachment>))

    assert_equal("\n", rendered)
  end

  test "removes a govspeak-embed-attachment-link element that has no matching attachment" do
    rendered = render_govspeak(%(<govspeak-embed-attachment-link id="missing"></govspeak-embed-attachment-link>))

    assert_equal("<p></p>\n", rendered)
  end
end
