<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--

        EDIT THE VARIABLES BELOW TO SUIT YOUR library
        Template-LVA-XSL

        To edit, change only the part between the > and < angle brackets
        For example:

            <xsl:variable name="name">Your library Name Here</xsl:variable>

        becomes:

            <xsl:variable name="name">Branch District library</xsl:variable>

-->

    <!-- change true to false to use the branch addresses as your return address, instead of the master address below -->
    <xsl:variable name="use_name">false</xsl:variable>

    <!-- Master address for your library or library system -->
    <xsl:variable name="master_name">East Central Regional library</xsl:variable>
    <xsl:variable name="master_street1">244 South Birch Street</xsl:variable>
    <xsl:variable name="master_city">Cambridge</xsl:variable>
    <xsl:variable name="master_state">MN</xsl:variable>
    <xsl:variable name="master_post_code">55008</xsl:variable>

    <!-- change false to true to display your library's phone, fax, and web address as part of the return address -->
    <xsl:variable name="use_lib_extras">true</xsl:variable>

    <xsl:variable name="master_phone">(763) 689-7390</xsl:variable>
    <xsl:variable name="master_fax">(763) 689-7389</xsl:variable>
    <xsl:variable name="master_www">http://ecrl.lib.mn.us/</xsl:variable>

    <!-- Insert the URL to your own logo for the return address here -->
    <!-- ideal size is between 50x50px and 75x75px -->
    <!-- leave blank for no logo -->
    <xsl:variable name="logo"/>

    <!-- Edit the variables below to customize the wording of the notices -->
    <xsl:variable name="heading1">Overdue Notice</xsl:variable>
    <xsl:variable name="heading2">Bill for Long-Overdue Items</xsl:variable>
    <xsl:variable name="sub_head1">First Notice</xsl:variable>
    <xsl:variable name="sub_head2">Final Notice</xsl:variable>
    <xsl:variable name="message1">You have item(s) overdue. Please return them to the library immediately.</xsl:variable>
    <xsl:variable name="message2">Please contact the library immediately about the items listed below.</xsl:variable>

    <!-- Edit the variables below to match the days overdue count you are using -->
    <xsl:variable name="notice0_count">7 days</xsl:variable>
    <xsl:variable name="notice1_count">14 days</xsl:variable>
    <xsl:variable name="notice2_count">21 days</xsl:variable>
    <xsl:variable name="notice3_count">42 days</xsl:variable>

    <!-- Change true to false to prevent scannable barcodes from being displayed -->
    <!-- note: barcode printing requires the Free 3 of 9 font, http://www.barcodesinc.com/free-barcode-font/ -->
    <xsl:variable name="use_barcodes">false</xsl:variable>

    <!-- NO NEED TO EDIT BELOW THIS POINT -->

    <xsl:template match="/">
        <html lang="en" xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
            <head>
                <link rel="stylesheet" type="text/css" media="all" href="http://lyrasistechnology.org/static/overdues-common.css"/>
                <link rel="stylesheet" type="text/css" media="print" href="http://lyrasistechnology.org/static/overdues-print.css"/>
                <title>Overdue Notices</title>
            </head>
            <body>
                <xsl:for-each select="file/agency/notice">
                    <xsl:sort select="library/name"/>
                    <div class="notice">
                        <div class="header">
                            <div class="header_page_num">
                                <p class="center">
                                    Page <xsl:value-of select="position()"/> of <xsl:value-of select="last()"/>
                                </p>
                            </div> <!-- end header_page_num div -->
                            <xsl:choose>
                                <xsl:when test="$logo = ''">
                                    <!-- do nothing -->
                                </xsl:when>
                                <xsl:otherwise>
                                <div class="logo">
                                    <img src="{$logo}"/>
                                    </div> <!-- end logo div -->
                                </xsl:otherwise>
                            </xsl:choose>
                            <div class="libadd">
                                <xsl:choose>
                                    <xsl:when test="$use_name = 'true'">
                                        <p class="line1">
                                            <xsl:value-of select="$master_name"/>
                                        </p>
                                        <p>
                                            <xsl:choose>
                                                <xsl:when test="$use_lib_extras = 'true'">
                                                    <xsl:value-of select="$master_street1"/>, <xsl:value-of select="$master_city"/>, <xsl:value-of select="$master_state"/> <xsl:value-of select="$master_post_code"/><br/>
                                                    <xsl:value-of select="$master_phone"/><br/>
                                                    Fax: <xsl:value-of select="$master_fax"/><br/>
                                                    <xsl:value-of select="$master_www"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$master_street1"/><br/>
                                                    <xsl:value-of select="$master_city"/>, <xsl:value-of select="$master_state"/> <xsl:value-of select="$master_post_code"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </p>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <p class="line1">
                                            <xsl:value-of select="library/name"/>
                                        </p>
                                        <p>
                                            <xsl:value-of select="library/addr_street1"/><br/>
                                            <xsl:if test="normalize-space(library/addr_street2)">
                                              <xsl:value-of select="library/addr_street2"/><br/>
                                            </xsl:if>
                                            <xsl:value-of select="library/addr_city"/>, <xsl:value-of select="library/addr_state"/> <xsl:value-of select="library/addr_post_code"/>
                                        </p>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div> <!-- end libadd div -->
                        </div> <!-- end header div -->
                        <div class="body">
                                <div class="borrower_id">
                                    Borrower ID: <xsl:value-of select="patron/id"/>
                                </div>
                            <div class="greeting">
                                <h2>
                                   <xsl:choose>
                                        <xsl:when test="@count = $notice3_count">
                                            <xsl:value-of select="$heading2"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$heading1"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </h2>
                                <p class="date">
                                    <span class="date"><xsl:value-of select="/file/@date"/></span>
                                    <xsl:choose>
                                        <xsl:when test="@count = $notice1_count">
                                             - <xsl:value-of select="$sub_head1"/>
                                        </xsl:when>
                                        <xsl:when test="@count = $notice2_count">
                                             - <span class="final_notice"><xsl:value-of select="$sub_head2"/></span>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- do nothing -->
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </p>
                                <p>
                                    <xsl:choose>
                                        <xsl:when test="@count = $notice3_count">
                                            <xsl:value-of select="$message2"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$message1"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </p>
                                <p>
                                    <xsl:value-of select="library/name"/>: <xsl:value-of select="library/phone"/>
                                </p>
                                <xsl:choose>
                                    <xsl:when test="@count = $notice3_count">
                                        <xsl:choose>
                                            <xsl:when test="$processing_fee = ''">
                                                <!-- do nothing -->
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <div class="processing_fee">
                                                    <p>
                                                        An additional <xsl:value-of select="$processing_fee"/> processing<br/>
                                                        fee will be added to each<br/>
                                                        item not returned.
                                                    </p>
                                                </div> <!-- end processing_fee div -->
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- do nothing -->
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div> <!-- end greeting div -->
                        </div> <!-- end body div -->

                        <xsl:choose>
                            <xsl:when test="@count = $notice3_count">
                                <xsl:choose>
                                    <xsl:when test="$max_fine = ''">
                                        <!-- do nothing -->
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <div class="disclaimer">
                                            <p>
                                                * Fines continue to accrue until the item is returned or the maximum fine of <xsl:value-of select="$max_fine"/> per item is reached.
                                            </p>
                                        </div>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- do nothing -->
                            </xsl:otherwise>
                        </xsl:choose>
                        <div class="generated_date">
                            <p>
                                (Generated on <xsl:value-of select="/file/@date"/>; <xsl:value-of select="position()"/>/<xsl:value-of select="last()"/>)
                            </p>
                        </div> <!-- end generated_date div -->
                            <div class="patron">
                                <p>
                                    <xsl:value-of select="patron/first_given_name"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="patron/family_name"/><br/>
                                    <xsl:value-of select="patron/addr_street1"/><br/>
                                    <xsl:if test="normalize-space(patron/addr_street2)">
                                      <xsl:value-of select="patron/addr_street2"/><br/>
                                    </xsl:if>
                                    <xsl:value-of select="patron/addr_city"/>, <xsl:value-of select="patron/addr_state"/> <xsl:value-of select="patron/addr_post_code"/>
                                </p>
                            </div> <!-- end patron div -->
                        <div class="footer">
                            <div class="footer_page_num">
                                <p class="center">
                                    Page <xsl:value-of select="position()"/> of <xsl:value-of select="last()"/>
                                </p>
                                <hr/>
                            </div> <!-- end footer_page_num div -->
                        </div> <!-- end footer div -->
                        <div class="page_break"/>
                    </div> <!-- end notice div -->
                </xsl:for-each>
                <script type="text/javascript">
                <![CDATA[

                    var spans = document.getElementsByTagName('span');
                    var d     = new Date();
                    var year  = d.getFullYear();
                    var month = d.getMonth() + 1;
                    var day   = d.getDate();
                    var today = month + '/' + day + '/' + year;

                    for (var i = 0; i < spans.length; i++)
                    {
                        // replace the date the report was generated with the date
                        // the report was printed.
                        if (spans[i].className == 'date')
                        {
                            spans[i].innerHTML = today;
                        }

                        // calculate the days overdue
                        if (spans[i].className == 'days_overdue')
                        {
                            var minutes = 1000 * 60;
                            var hours   = minutes * 60;
                            var days    = hours * 24;

                            var due_date = spans[i-1].innerHTML;

                            var today_millisecs     = Date.parse(today);
                            var due_date_millisecs = Date.parse(due_date);

                            var days_overdue = Math.floor((today_millisecs - due_date_millisecs) / days);

                            spans[i].innerHTML = days_overdue;
                        }
                    }
                ]]>
                </script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
