import unittest
from pathlib import Path

from sync_signatures import fields, render

TEMPLATE = Path(__file__).with_name("template.html").read_text()


class RenderTest(unittest.TestCase):
    def test_full_user(self):
        user = {
            "primaryEmail": "buzz@everbetter.com",
            "name": {"fullName": "Buzz"},
            "organizations": [{"title": "Chief Technology Officer", "primary": True}],
            "phones": [{"value": "316-644-4017", "type": "work", "primary": True}],
        }
        out = render(TEMPLATE, fields(user))
        self.assertIn("Chief Technology Officer | Everbetter", out)
        self.assertIn('href="tel:3166444017"', out)
        self.assertIn(">316-644-4017<", out)
        self.assertIn("mailto:buzz@everbetter.com", out)

    def test_missing_phone_drops_line(self):
        user = {"primaryEmail": "a@everbetter.com", "name": {"fullName": "A"},
                "organizations": [{"title": "Engineer"}]}
        out = render(TEMPLATE, fields(user))
        self.assertNotIn("tel:", out)
        self.assertIn("Engineer | Everbetter", out)

    def test_html_escaped(self):
        user = {"primaryEmail": "x@everbetter.com",
                "name": {"fullName": "<script>alert(1)</script>"}}
        out = render(TEMPLATE, fields(user))
        self.assertNotIn("<script>", out)
        self.assertIn("&lt;script&gt;", out)

    def test_deterministic(self):
        user = {"primaryEmail": "x@everbetter.com", "name": {"fullName": "X"}}
        self.assertEqual(render(TEMPLATE, fields(user)), render(TEMPLATE, fields(user)))


if __name__ == "__main__":
    unittest.main()
