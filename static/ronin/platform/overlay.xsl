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
            font-size: 0.9em;
            margin: 0;
            padding: 0;
          }

          #overlay {
            margin: 1em;
            padding: 1em;
            border: 20px solid black;
          }

          #overlay p {
            margin: 0.125em;
            padding: 0;
          }

          #overlay strong {
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

          #overlay-description {
          }
        </style>
        <style type="text/css" media="print">
          #overlay {
            border: none;
          }

          #overlay a {
            font-weight: normal;
          }
        </style>
      </head>

      <body>
        <table id="overlay">
          <xsl:apply-templates />
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="/ronin-overlay/title">
    <tr id="overlay-title">
      <td valign="top">
        <p><strong>Title:</strong></p>
      </td>
      <td valign="top">
        <p><xsl:value-of select="." /></p>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="/ronin-overlay/license">
    <tr id="overlay-license">
      <td valign="top">
        <p><strong>License:</strong></p>
      </td>
      <td valign="top">
        <p><xsl:value-of select="." /></p>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="/ronin-overlay/source">
    <tr id="overlay-source">
      <td valign="top">
        <p><strong>Source:</strong></p>
      </td>
      <td valign="top">
        <p>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
            <xsl:value-of select="." />
          </a>
        </p>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="/ronin-overlay/source-view">
    <tr id="overlay-source-view">
      <td valign="top">
        <p><strong>View Source:</strong></p>
      </td>
      <td valign="top">
        <p>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
            <xsl:value-of select="." />
          </a>
        </p>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="/ronin-overlay/website">
    <tr id="overlay-website">
      <td valign="top">
        <p><strong>Website:</strong></p>
      </td>
      <td valign="top">
        <p>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
            <xsl:value-of select="." />
          </a>
        </p>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="/ronin-overlay/maintainers">
    <tr id="overlay-maintainers">
      <td valign="top">
        <p><strong>Maintainers:</strong></p>
      </td>
      <td valign="top">
        <xsl:apply-templates />
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="/ronin-overlay/maintainers/maintainer">
    <p class="maintainer">
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
    <tr id="overlay-description">
      <td valign="top">
        <p><strong>Description:</strong></p>
      </td>
      <td valign="top">
        <p><xsl:value-of select="." /></p>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
