<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">




	<xsl:template match="/">
		<html lang="en" xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
            <head>
                <title>Families</title>
            </head>
            <body>
				<h1>Hello Families</h1><br />
				<table border="2">
					<tr>
						<xsl:apply-templates />
					</tr>
				</table>
				
				
			</body>
		</html>







	</xsl:template>
	<xsl:template match="husband">
		<td border="2"><xsl:value-of select="name" /></td>
	</xsl:template>


</xsl:stylesheet>
