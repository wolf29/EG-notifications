<?xml version="1.0" encoding="ISO-8859-1"?> 
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- # Copyright 2008 The Evergreen-ILS Project -->
<!-- 

        EDIT THE VARIABLES BELOW TO SUIT YOUR LIBRARY

        To edit, change only the part between the > and < angle brackets
        For example: 
        
            <xsl:variable name="lib_name">Your Library Name Here</xsl:variable>
        
        becomes:
        
            <xsl:variable name="lib_name">Branch District Library</xsl:variable> 

-->

    <!-- change true to false to use the branch addresses as your return address, instead of the master address below -->
    <xsl:variable name="use_lib_name">false</xsl:variable>
    
    <!-- Master address for your library or library system -->
    <xsl:variable name="lib_name">Your Library Name Here</xsl:variable>
    <xsl:variable name="lib_street1">Number Street</xsl:variable>
    <xsl:variable name="lib_city_state_zip">City, State ZIP</xsl:variable>
    
    <!-- 
        change to false to leave the logo out. 
        NOTE: you will then need to edit the 'top' and 'left' values for the '.libadd' class in 'overdues-common.css' for the return address to be positioned properly. 
        
        Put your own SVG logo in the code below if you wish.    
    -->
    <xsl:variable name="lib_logo">true</xsl:variable>
    
    <!-- change false to true to display your library's phone, fax, and web address as part of the return address -->
    <xsl:variable name="use_lib_extras">true</xsl:variable>
    
    <xsl:variable name="lib_phone">123-456-7890</xsl:variable>
    <xsl:variable name="lib_fax">123-456-7891</xsl:variable>
    <xsl:variable name="lib_www">www.your-library.org</xsl:variable>
    
    <!-- Edit the variables below to customize the wording of the notices -->
    <xsl:variable name="heading1">Overdue Notice</xsl:variable>
    <xsl:variable name="heading2">Bill for Long-Overdue Items</xsl:variable>
    <xsl:variable name="sub_head1">First Notice</xsl:variable>
    <xsl:variable name="sub_head2">Final Notice</xsl:variable>
    <xsl:variable name="message1">You have item(s) overdue. Please return them to the library immediately.</xsl:variable>
    <xsl:variable name="message2">Please contact the library immediately about the items listed below.</xsl:variable>
   

    <!-- Edit the variables below to match the days overdue count you are using -->
    <xsl:variable name="notice0_count">7day</xsl:variable>
    <xsl:variable name="notice1_count">14day</xsl:variable>
    <xsl:variable name="notice2_count">28day</xsl:variable>
    <xsl:variable name="notice3_count">45day</xsl:variable>
    
    <!-- Change true to false to prevent scannable barcodes from being displayed -->
    <!-- note: barcode printing requires the Free 3 of 9 font, http://www.barcodesinc.com/free-barcode-font/ -->
    <xsl:variable name="use_barcodes">true</xsl:variable>
    
    <!-- Evergreen knows the two values below, but you need to enter them here for the message to the patron -->
    <!-- leave processing_fee blank if you have no processing fee -->
    <xsl:variable name="processing_fee">$5.00</xsl:variable>
    <!-- leave max_fine blank if you have no processing fee -->
    <xsl:variable name="max_fine">$5.00</xsl:variable>

    <!-- NO NEED TO EDIT BELOW THIS POINT -->
    <xsl:template match="/">    
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"> 
            <head> 
                <link rel="stylesheet" type="text/css" media="all" href="ppl-overdues-common.css" /> 
                <link rel="stylesheet" type="text/css" media="print" href="ppl-overdues-print.css" /> 
                <title>Overdue Notices</title> 
            </head> 
            <body> 
                <xsl:for-each select="file/agency/notice">
                    <xsl:sort select="library/libname"/> 
                    <div class="notice"> 
                        <div class="header"> 
                            <div class="header_page_num"> 
                                <p class="center"> 
                                    Page <xsl:value-of select="position()"/> of <xsl:value-of select="last()"/> 
                                </p> 
                            </div> <!-- end header_page_num div --> 
                            <xsl:choose> 
                                <xsl:when test="$lib_logo = 'false'">  
                                    <!-- do nothing -->
                                </xsl:when> 
                                <xsl:otherwise> 
                                <div class="logo"> 
                                </div> <!-- end logo div -->
                                </xsl:otherwise> 
                            </xsl:choose>                      
                            <div class="libadd"> 
                                <xsl:choose> 
                                    <xsl:when test="$use_lib_name = 'true'">
                                        <p class="line1">
                                            <xsl:value-of select="$lib_name"/> 
                                        </p> 
                                        <p>
                                            <xsl:choose> 
                                                <xsl:when test="$use_lib_extras = 'true'">
                                                    <xsl:value-of select="$lib_street1"/>, <xsl:value-of select="$lib_city_state_zip"/><br />
                                                    <xsl:value-of select="$lib_phone"/><br />
                                                    Fax: <xsl:value-of select="$lib_fax"/><br />
                                                    <xsl:value-of select="$lib_www"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$lib_street1"/><br />
                                                    <xsl:value-of select="$lib_city_state_zip"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </p>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <p class="line1">
                                            <xsl:value-of select="library/libname"/>
                                        </p> 
                                        <p> 
                                            <xsl:value-of select="library/libstreet1"/><br />
                                            <xsl:value-of select="library/libcity_state_zip"/>
                                        </p>
                                    </xsl:otherwise>
                                </xsl:choose> 
                            </div> <!-- end libadd div --> 
                        </div> <!-- end header div --> 
                        <div class="body">
                            <div class="patron"> 
                                <p> 
                                    <xsl:value-of select="patron/fullname"/><br /> 
                                    <xsl:value-of select="patron/street1"/><br /> 
                                    <xsl:value-of select="patron/city_state_zip"/>
                                </p> 
                                <p class="borrower_id"> 
                                    Borrower ID: <xsl:value-of select="patron/id"/> 
                                </p>
                                <xsl:choose> 
                                    <xsl:when test="$use_barcodes = 'false'">
                                        <p class="barcode"> 
                                            *<xsl:value-of select="patron/id"/>* 
                                        </p> 
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <p></p>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div> <!-- end patron div --> 
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
                                    <span class="date"><xsl:value-of select="/file/@date" /></span> 
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
                                    <xsl:value-of select="library/libname" />: <xsl:value-of select="library/libphone" /> 
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
                                                        An additional <xsl:value-of select="$processing_fee"/> processing<br /> 
                                                        fee will be added to each<br /> 
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
                        <table class="list"> 
                            <xsl:choose> 
                                <xsl:when test="@count = $notice3_count"> 
                                    <thead> 
                                        <th>Title / Call #</th> 
                                        <th>Item ID (Barcode)</th> 
                                        <th>Check Out Date</th> 
                                        <th>Due Date</th> 
                                        <th>Days Overdue</th> 
                                        <th>Item Price</th> 
                                        <th>Fines to Date</th> 
                                    </thead>
                                    <tbody> 
                                    <xsl:for-each select="item"> 
                                        <xsl:sort select="title"/> 
                                        <tr class="zebra"> 
                                            <td><xsl:value-of select="title"/></td> 
                                            <td><xsl:value-of select="barcode"/></td> 
                                            <td><xsl:value-of select="check_out"/></td> 
                                            <td><span class="due_date"><xsl:value-of select="duedate"/></span></td> 
                                            <td class="days_overdue"><span class="days_overdue"></span></td> 
                                            <td class="right">$ <xsl:value-of select="item_price"/></td> 
                                            <td class="right">$ <xsl:value-of select="fine"/></td> 
                                        </tr> 
                                        <tr class="zebra"> 
                                            <td><xsl:value-of select="callno"/></td> 
                                            <xsl:choose> 
                                                <xsl:when test="$use_barcodes = 'true'">
                                                    <td class="barcode">*<xsl:value-of select="barcode"/>*</td>
                                                </xsl:when> 
                                                <xsl:otherwise>
                                                    <td></td>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <td colspan="5"><xsl:value-of select="location"/></td>                 
                                        </tr> 
                                    </xsl:for-each> 
                                    <tr> 
                                        <td colspan="5"></td> 
                                        <td colspan="2"><hr /></td> 
                                    </tr> 
                                    <tr> 
                                        <td colspan="5"></td> 
                                        <td class="center">Total Replacement Cost</td> 
                                        <td class="center">Total Fines to Date*</td> 
                                    </tr> 
                                    <tr> 
                                        <td colspan="6" class="right">$ 
                                            <xsl:variable name="replacement_total_a"> 
                                                <xsl:value-of select="sum(item/item_price)"/> 
                                            </xsl:variable> 
                                            <xsl:variable name="replacement_total_b"> 
                                                <xsl:value-of select="round($replacement_total_a*100)div 100"/> 
                                            </xsl:variable> 
                                            <xsl:choose> 
                                                <xsl:when test="$replacement_total_b=floor($replacement_total_b)"> 
                                                    <xsl:value-of select="$replacement_total_b"/>.00 
                                                </xsl:when> 
                                                <xsl:when test="string-length(substring-after($replacement_total_b,'.'))='1'"> 
                                                    <xsl:value-of select="$replacement_total_b"/>0 
                                                </xsl:when> 
                                                <xsl:otherwise> 
                                                    <xsl:value-of select="$replacement_total_b"/> 
                                                </xsl:otherwise> 
                                            </xsl:choose>
                                        </td> 
                                        <td class="right">$ 
                                            <xsl:variable name="fine_total_a"> 
                                                <xsl:value-of select="sum(item/fine)"/> 
                                            </xsl:variable> 
                                            <xsl:variable name="fine_total_b"> 
                                                <xsl:value-of select="round($fine_total_a*100)div 100"/> 
                                            </xsl:variable> 
                                            <xsl:choose> 
                                                <xsl:when test="$fine_total_b=floor($fine_total_b)"> 
                                                    <xsl:value-of select="$fine_total_b"/>.00 
                                                </xsl:when> 
                                                <xsl:when test="string-length(substring-after($fine_total_b,'.'))='1'"> 
                                                    <xsl:value-of select="$fine_total_b"/>0 
                                                </xsl:when> 
                                                <xsl:otherwise> 
                                                    <xsl:value-of select="$fine_total_b"/> 
                                                </xsl:otherwise> 
                                            </xsl:choose>
                                        </td> 
                                    </tr>
                                    </tbody>
                                </xsl:when> 
                                <!-- ################################# -->
                                <xsl:otherwise> 
                                    
                                    <thead> 
                                        <th>Title / Call #</th> 
                                        <th>Item ID (Barcode)</th> 
                                        <th>Check Out Date</th> 
                                        <th>Due Date</th> 
                                        <th>Days Overdue</th> 
                                        <th>Item Price</th> 
                                        <th>Fines to Date</th> 
                                    </thead>
                                    <tbody> 
                                    <xsl:for-each select="item"> 
                                        <xsl:sort select="title"/> 
                                        <tr class="zebra"> 
                                            <td><xsl:value-of select="title"/></td> 
                                            <td><xsl:value-of select="barcode"/></td> 
                                            <td><xsl:value-of select="check_out"/></td> 
                                            <td><span class="due_date"><xsl:value-of select="duedate"/></span></td> 
                                            <td class="days_overdue"><span class="days_overdue"></span></td> 
                                            <td class="right">$ <xsl:value-of select="item_price"/></td> 
                                            <td class="right">$ <xsl:value-of select="fine"/></td> 
                                        </tr> 
                                        <tr class="zebra"> 
                                            <td><xsl:value-of select="callno"/></td> 
                                            <xsl:choose> 
                                                <xsl:when test="$use_barcodes = 'true'">
                                                    <td class="barcode">*<xsl:value-of select="barcode"/>*</td>
                                                </xsl:when> 
                                                <xsl:otherwise>
                                                    <td></td>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <td colspan="5"><xsl:value-of select="location"/></td>                 
                                        </tr> 
                                    </xsl:for-each> 
                                    <tr> 
                                        <td colspan="5"></td> 
                                        <td colspan="2"><hr /></td> 
                                    </tr> 
                                    <tr> 
                                        <td colspan="5"></td> 
                                        <td class="center">Total Replacement Cost</td> 
                                        <td class="center">Total Fines to Date*</td> 
                                    </tr> 
                                    <tr> 
                                        <td colspan="6" class="right">$ 
                                            <xsl:variable name="replacement_total_a"> 
                                                <xsl:value-of select="sum(item/item_price)"/> 
                                            </xsl:variable> 
                                            <xsl:variable name="replacement_total_b"> 
                                                <xsl:value-of select="round($replacement_total_a*100)div 100"/> 
                                            </xsl:variable> 
                                            <xsl:choose> 
                                                <xsl:when test="$replacement_total_b=floor($replacement_total_b)"> 
                                                    <xsl:value-of select="$replacement_total_b"/>.00 
                                                </xsl:when> 
                                                <xsl:when test="string-length(substring-after($replacement_total_b,'.'))='1'"> 
                                                    <xsl:value-of select="$replacement_total_b"/>0 
                                                </xsl:when> 
                                                <xsl:otherwise> 
                                                    <xsl:value-of select="$replacement_total_b"/> 
                                                </xsl:otherwise> 
                                            </xsl:choose>
                                        </td> 
                                        <td class="right">$ 
                                            <xsl:variable name="fine_total_a"> 
                                                <xsl:value-of select="sum(item/fine)"/> 
                                            </xsl:variable> 
                                            <xsl:variable name="fine_total_b"> 
                                                <xsl:value-of select="round($fine_total_a*100)div 100"/> 
                                            </xsl:variable> 
                                            <xsl:choose> 
                                                <xsl:when test="$fine_total_b=floor($fine_total_b)"> 
                                                    <xsl:value-of select="$fine_total_b"/>.00 
                                                </xsl:when> 
                                                <xsl:when test="string-length(substring-after($fine_total_b,'.'))='1'"> 
                                                    <xsl:value-of select="$fine_total_b"/>0 
                                                </xsl:when> 
                                                <xsl:otherwise> 
                                                    <xsl:value-of select="$fine_total_b"/> 
                                                </xsl:otherwise> 
                                            </xsl:choose>
                                        </td> 
                                    </tr>
                                    </tbody>
                                  <!--  <thead> 
                                        <th>Title</th> 
                                        <th>Author</th> 
                                        <th>Call Number</th> 
                                        <th>Item ID</th> 
                                        <th>Location</th>
                                        <th>Due Date</th> 
                                    </thead>
                                    <tbody> 
                                    <xsl:for-each select="item"> 
                                        <xsl:sort select="title"/> 
                                        <tr class="zebra"> 
                                            <td><xsl:value-of select="title"/></td> 
                                            <td><xsl:value-of select="author"/></td> 
                                            <td><xsl:value-of select="callno"/></td> 
                                            <td><xsl:value-of select="barcode"/></td> 
                                            <td><xsl:value-of select="location"/></td>
                                            <td><xsl:value-of select="duedate"/></td> 
                                        </tr>
                                        <xsl:choose> 
                                            <xsl:when test="$use_barcodes = 'true'">
                                                <tr class="zebra"> 
                                                    <td></td> 
                                                    <td></td> 
                                                    <td></td> 
                                                    <td class="barcode">*<xsl:value-of select="barcode"/>*</td> 
                                                    <td></td> 
                                                    <td></td>
                                                </tr>
                                            </xsl:when>
                                            <xsl:otherwise>  -->
                                                <!-- do nothing -->
                                      <!--      </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                    </tbody> -->
                                </xsl:otherwise> 
                            </xsl:choose>
                        </table>
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
                            </xsl:otherwise>  -->
                        </xsl:choose>
                        <div class="generated_date"> 
                            <p> 
                                (Generated on <xsl:value-of select="/file/@date" />; <xsl:value-of select="position()"/>/<xsl:value-of select="last()"/>) 
                            </p> 
                        </div> <!-- end generated_date div --> 
                        <div class="footer"> 
                            <div class="footer_page_num"> 
                                <p class="center"> 
                                    Page <xsl:value-of select="position()"/> of <xsl:value-of select="last()"/> 
                                </p> 
                                <hr /> 
                            </div> <!-- end footer_page_num div -->
                        </div> <!-- end footer div -->
                        <div class="page_break"></div> 
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
                    
                    // zebra-stripe the tables for easier reading
                    if (document.getElementsByTagName) 
                    { 
                        tables = document.getElementsByTagName("table");
                        for (j = 0; j < tables.length; j++)
                        {
                            for ( k = 2; k < tables[j].rows.length; k = k + 4)
                            {
                                // if the classname includes 'zebra'
                                if (tables[j].rows[k].className.indexOf('zebra') > -1)
                                tables[j].rows[k].className='colored';
                            }
                            for ( k = 3; k < tables[j].rows.length; k = k + 4)
                            {
                                // if the classname includes 'zebra'
                                if (tables[j].rows[k].className.indexOf('zebra') > -1)
                                tables[j].rows[k].className='colored';
                            }
                        }
                    }

                ]]> 
                </script> 
            </body> 
        </html> 
    </xsl:template> 
</xsl:stylesheet> 
