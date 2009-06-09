<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" indent="yes" />

  <xsl:template match="/ronin-overlay">
    <html>
      <head>
        <title>Ronin Overlay :: <xsl:value-of select="/ronin-overlay/title/." /></title>
        <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=UTF-8" />
        <style type="text/css">
          body {
          }

          #overlay {
            margin: 0.5em;
            padding: 0.2em;
            border: 20px solid black;
          }

          #overlay-title {
          }

          #overlay-license {
          }

          #overlay-url {
          }

          #overlay-description {
          }

          #overlay-description blockquote {
          }
        </style>
        <script type="text/javascript" src="http://ronin.rubyforge.org/scripts/jquery.min.js"></script>
        <script type="text/javascript" src="http://ronin.rubyforge.org/scripts/jquery.expander.js"></script>
        <script type="text/javascript">
          $(document).ready(function() {
            $("#overlay-description/blockquote").expander({
              expandText: '[ more ]',
              userCollapseText: '[ less ]'
            });
          });
        </script>
      </head>

      <body>
        <div id="overlay">
          <xsl:apply-templates />
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="/ronin-overlay/title">
    <p id="overlay-title">
      <strong>Title:</strong> <xsl:value-of select="." />
    </p>
  </xsl:template>

  <xsl:template match="/ronin-overlay/license">
    <p id="overlay-license">
      <strong>License:</strong> <xsl:value-of select="." />
    </p>
  </xsl:template>

  <xsl:template match="/ronin-overlay/source">
    <p id="overlay-source">
      <strong>Source:</strong>
      <a>
        <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
        <xsl:value-of select="." />
      </a>
    </p>
  </xsl:template>

  <xsl:template match="/ronin-overlay/source-browse">
    <p id="overlay-source-browse">
      <strong>Source Browser:</strong>
      <a>
        <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
        <xsl:value-of select="." />
      </a>
    </p>
  </xsl:template>

  <xsl:template match="/ronin-overlay/website">
    <p id="overlay-website">
      <strong>Website:</strong>
      <a>
        <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
        <xsl:value-of select="." />
      </a>
    </p>
  </xsl:template>

  <xsl:template match="/ronin-overlay/description">
    <div id="overlay-description">
      <p><strong>Description:</strong></p>
      <blockquote><xsl:value-of select="." /></blockquote>
    </div>
  </xsl:template>
</xsl:stylesheet>
