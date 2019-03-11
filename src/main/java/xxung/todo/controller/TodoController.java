package xxung.todo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import xxung.todo.service.TodoService;

@Controller
public class TodoController {
    Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "todoService")
	private TodoService todoService;
	
 	@RequestMapping(value = "/todo/todoList.do")
	public ModelAndView todoListPage(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mv = new ModelAndView("todo/todoList");
		
		return mv;
	}
	
 	@RequestMapping(value = "/todo/getTodoList.do")
	public @ResponseBody List<Map<String, Object>> getTodoList(HttpServletRequest req) throws Exception {
 		int paging = Integer.parseInt(req.getParameter("page"));
 		int offset = 10 * (paging - 1);
 		List<Map<String, Object>> result = todoService.getTodoList(offset);
 		
//		log.debug(" Request login Fail \t:  ID is null");
 		
		return result;
	}
	
 	@RequestMapping(value = "/todo/getPaging.do")
	public @ResponseBody int getPaging(HttpServletRequest req) throws Exception {
 		int result = todoService.getPaging();
 		
		return result;
	}
	
 	@RequestMapping(value = "/todo/saveTodoList.do")
	public @ResponseBody void saveTodoList(HttpServletRequest req) throws Exception {
 		String title = req.getParameter("title");
 		String contents = req.getParameter("contents");
 		String deadline = req.getParameter("deadline");
 		String priority = req.getParameter("priority");
 		String list_key = req.getParameter("list_key");
 		todoService.removePriority(list_key);
 		if(priority != null && !priority.equals("")) {
 	 		int parse_num = Integer.parseInt(priority);
 	 		todoService.orderPriority(parse_num);
 		}
 		
 		Map<String, Object> param = new HashMap<String, Object>();
 		param.put("title", title);
 		param.put("contents", contents);
 		param.put("deadline", deadline);
 		param.put("priority", priority);
 		param.put("list_key", list_key);
 		todoService.saveTodoList(param);
	}
	
 	@RequestMapping(value = "/todo/createTodoList.do")
	public @ResponseBody void createTodoList(HttpServletRequest req) throws Exception {
 		String title = req.getParameter("title");
 		String contents = req.getParameter("contents");
 		String deadline = req.getParameter("deadline");
 		String priority = req.getParameter("priority");
 		if(priority != null && !priority.equals("")) {
 	 		int parse_num = Integer.parseInt(priority);
 	 		todoService.orderPriority(parse_num);
 		}
 		
 		Map<String, Object> param = new HashMap<String, Object>();
 		param.put("title", title);
 		param.put("contents", contents);
 		param.put("deadline", deadline);
 		param.put("priority", priority);
		todoService.createTodoList(param);
	}
	
 	@RequestMapping(value = "/todo/getTodoDetail.do")
	public @ResponseBody Map<String, Object> getTodoDetail(HttpServletRequest req) throws Exception {
 		String list_key = req.getParameter("list_key");

 		Map<String, Object> result = todoService.getTodoDetail(list_key);
 		
		return result;
	}
	
 	@RequestMapping(value = "/todo/completeTodo.do")
	public @ResponseBody void completeTodo(HttpServletRequest req) throws Exception {
 		String list_key = req.getParameter("list_key");
 		
 		todoService.completeTodo(list_key);
 		int max_priority = todoService.getMaxPriority();
 		todoService.orderPriority(max_priority);
	}
	
 	@RequestMapping(value = "/todo/deleteTodo.do")
	public @ResponseBody void deleteTodo(HttpServletRequest req) throws Exception {
 		String list_key = req.getParameter("list_key");
 		
 		todoService.deleteTodo(list_key);
 		int max_priority = todoService.getMaxPriority();
 		todoService.orderPriority(max_priority);
	}
	
 	@RequestMapping(value = "/todo/addPriority.do")
	public @ResponseBody void addPriority(HttpServletRequest req) throws Exception {
 		String priority = req.getParameter("priority");
 		String list_key = req.getParameter("list_key");
 		Map<String, Object> param = new HashMap<String, Object>();
 		param.put("priority", priority);
 		param.put("list_key", list_key);
 		todoService.addPriority(param);
	}
	
 	@RequestMapping(value = "/todo/orderPriority.do")
	public @ResponseBody void orderPriority(HttpServletRequest req) throws Exception {
 		String num = req.getParameter("num");
 		int parse_num = Integer.parseInt(num);
 		todoService.orderPriority(parse_num);
	}
	
 	@RequestMapping(value = "/todo/getMaxPriority.do")
	public @ResponseBody int getMaxPriority(HttpServletRequest req) throws Exception {
 		int result = todoService.getMaxPriority();
 		
		return result;
	}
	
 	@RequestMapping(value = "/todo/removePriority.do")
	public @ResponseBody void removePriority(HttpServletRequest req) throws Exception {
 		String list_key = req.getParameter("list_key");
 		todoService.removePriority(list_key);
	}
	
 	@RequestMapping(value = "/todo/moveExprationTodo.do")
	public @ResponseBody List<Map<String, Object>> moveExprationTodo(HttpServletRequest req) throws Exception {
 		todoService.moveExprationTodo();
 		List<Map<String, Object>> result = todoService.getExprationTodo();
		return result;
	}
	
 	@RequestMapping(value = "/todo/moveAlarm.do")
	public @ResponseBody void moveAlarm(HttpServletRequest req) throws Exception {
 		String list_key = req.getParameter("list_key");
 		todoService.moveAlarm(list_key);
 		todoService.removePriority(list_key);
	}
}
