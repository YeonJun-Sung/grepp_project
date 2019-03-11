package xxung.todo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import xxung.todo.dao.TodoDAO;

@Service("todoService")
public class TodoServiceImpl implements TodoService {
	@Resource(name="todoDAO")
    private TodoDAO todoDAO;

    Logger log = Logger.getLogger(this.getClass());

	@Override
	public List<Map<String, Object>> getTodoList(int offset) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("offset", offset);
		return todoDAO.getTodoList(param);
	}

	@Override
	public int getPaging() throws Exception {
		// TODO Auto-generated method stub
		return todoDAO.getPaging();
	}

	@Override
	public void createTodoList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		String key = todoDAO.saveTodoListContents(param);
		log.debug(" Add list key \t:  " + key);
		param.put("list_key", key);
		todoDAO.saveTodoListPriority(param);
		todoDAO.saveTodoListStatus(param);
	}

	@Override
	public Map<String, Object> getTodoDetail(String list_key) throws Exception {
		// TODO Auto-generated method stub
		return todoDAO.getTodoDetail(list_key);
	}

	@Override
	public void completeTodo(String list_key) throws Exception {
		// TODO Auto-generated method stub
		todoDAO.completeTodo(list_key);
		todoDAO.removePriority(list_key);
	}

	@Override
	public void deleteTodo(String list_key) throws Exception {
		// TODO Auto-generated method stub
		todoDAO.deleteTodo(list_key);
	}

	@Override
	public void saveTodoList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		String priority = (String) param.get("priority");
		todoDAO.editTodoListContents(param);
		if(priority != null && !priority.equals(""))
			todoDAO.editTodoListPriority(param);
		todoDAO.editTodoListStatus(param);
	}

	@Override
	public void addPriority(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		todoDAO.addPriority(param);
	}

	@Override
	public void orderPriority(int num) throws Exception {
		// TODO Auto-generated method stub
		List<Map<String, Object>> list = todoDAO.getPriorityList();

		if(list.size() != 0) {
			for(int i = 0;i < list.size();i++) {
				if(i + 1 >= num)
					list.get(i).put("list_pri", i + 2);
				else
					list.get(i).put("list_pri", i + 1);
			}
			todoDAO.updatePriority(list);	
		}
	}

	@Override
	public int getMaxPriority() throws Exception {
		// TODO Auto-generated method stub
		return todoDAO.getMaxPriority();
	}

	@Override
	public void removePriority(String list_key) throws Exception {
		// TODO Auto-generated method stub
		todoDAO.removePriority(list_key);
	}

	@Override
	public void moveExprationTodo() throws Exception {
		// TODO Auto-generated method stub
		todoDAO.moveExprationTodo();
	}

	@Override
	public List<Map<String, Object>> getExprationTodo() throws Exception {
		// TODO Auto-generated method stub
		return todoDAO.getExprationTodo();
	}

	@Override
	public void moveAlarm(String list_key) throws Exception {
		// TODO Auto-generated method stub
		todoDAO.moveAlarm(list_key);
	}
    
}