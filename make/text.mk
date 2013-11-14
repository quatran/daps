# Copyright (C) 2012 SUSE Linux Products GmbH
#
# Author: Frank Sundermeyer
#
# ASCII generation for DAPS
#
# Please submit feedback or patches to
# <fsundermeyer at opensuse dot org>
#

# includes are set in selector.mk
# include $(DAPSROOT)/make/setfiles.mk
# include $(DAPSROOT)/make/profiling.mk
# include $(DAPSROOT)/make/validate.mk
# include $(DAPSROOT)/make/images.mk
# include $(DAPSROOT)/make/html.mk
# include $(DAPSROOT)/make/text.mk

STYLETXT := $(firstword $(wildcard \
		$(addsuffix /xhtml/docbook.xsl,$(STYLE_ROOTDIRS))))

.PHONY: text
text: $(TXT_RESULT)
	@ccecho "result" "Find the TEXT book at:\n$(TXT_RESULT)"

$(TXT_RESULT): $(TMP_DIR)/$(DOCNAME).html 
  ifeq ($(VERBOSITY),2)
	@ccecho "info" "   Creating ASCII file"
  endif
	w3m -dump $< > $@

# The text file is generated via w3m from a single HTML file. We do not need
# to create images, css files and stuff, therefore we create a temporary
# single html file rather than using the existing single-html target
# (it's initially faster because no images will be created)
#
$(TMP_DIR)/$(DOCNAME).html: | $(TMP_DIR)
$(TMP_DIR)/$(DOCNAME).html: $(DOCFILES) $(PROFILES) $(PROFILEDIR)/.validate
  ifeq ($(VERBOSITY),2)
	@ccecho "info" "   Creating temporary single HTML page"
  endif
	$(XSLTPROC) $(ROOTSTRING) $(XSLTPARAM) \
	  --output $(TMP_DIR)/$(DOCNAME).html --xinclude \
	  --stylesheet $(STYLETXT) --file $(PROFILED_MAIN) \
	  $(XSLTPROCESSOR) $(DEVNULL) $(ERR_DEVNULL)
