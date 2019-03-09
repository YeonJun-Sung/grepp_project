package xxung.todo.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import xxung.todo.service.TodoService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class TodoController {

	@Resource(name = "todoService")
	private TodoService todoService;
	
 	@RequestMapping(value = "/todo/todoList.do")
	public ModelAndView supportPage(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mv = new ModelAndView("todo/todoList");
		
		return mv;
	}
}
