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
            font-family: sans-serif;
          }

          #overlay {
            margin: 1em;
            padding: 1em;
            border: 20px solid black;
          }

          #overlay p {
            margin: 0.5em;
            padding: 0;
          }

          #overlay p strong {
            margin-right: 1em;
          }

          #overlay a {
            color: black;
            font-weight: bold;
            text-decoration: none;
          }

          #overlay a:hover {
            color: #BD0000;
          }

          #overlay-title {
          }

          #overlay-license {
          }

          #overlay-url {
          }

          #overlay-maintainers {
            margin: 0 1em 0 1em;
            padding: 0;
          }

          #overlay-description {
          }

          #overlay-description blockquote {
          }
        </style>
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

  <xsl:template match="/ronin-overlay/source-view">
    <p id="overlay-source-view">
      <strong>View Source:</strong>
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

  <xsl:template match="/ronin-overlay/maintainers">
    <p><strong>Maintainers:</strong></p>
    <div id="overlay-maintainers">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="/ronin-overlay/maintainers/maintainer">
    <p>
      <xsl:choose>
        <xsl:when test="email">
          <a>
            <xsl:attribute name="href">mailto:<xsl:value-of select="email/." /></xsl:attribute>
            <xsl:value-of select="name/." />
          </a>
        </xsl:when>

        <xsl:otherwise>
          <strong><xsl:value-of select="name/." /></strong>
        </xsl:otherwise>
      </xsl:choose>
    </p>
  </xsl:template>

  <xsl:template match="/ronin-overlay/description">
    <div id="overlay-description">
      <p><strong>Description:</strong></p>
      <blockquote><xsl:value-of select="." /></blockquote>
    </div>
  </xsl:template>
</xsl:stylesheet>
