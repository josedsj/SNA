#!/usr/bin/env python
# coding: utf-8

# In[1]:


import networkx as nx


# In[2]:


G=nx.Graph()


# In[3]:


G.add_node(1)


# In[4]:


G.add_node(2)
G.add_node(3)
G.add_node(4)
G.add_node(5)
G.add_node(6)


# In[6]:


nx.draw(G,with_labels=True)


# In[7]:


G.add_edge(1,2)


# In[8]:


G.add_edge(1,3)
G.add_edge(1,4)
G.add_edge(1,5)
G.add_edge(1,6)


# In[9]:


nx.draw(G,with_labels=True)


# In[10]:


G.number_of_edges()


# In[11]:


G.size()


# In[12]:


G.number_of_nodes()


# In[13]:


G.order()


# In[14]:


nx.degree(G)


# In[15]:


nx.density(G)


# In[17]:


G.number_of_edges()*2/(G.number_of_nodes()*(G.number_of_nodes()-1))


# In[18]:


nx.diameter(G)


# In[19]:


H=nx.complete_graph(6)


# In[20]:


nx.draw(H,with_labels=True)


# In[21]:


H.number_of_edges()


# In[22]:


H.number_of_nodes()


# In[23]:


nx.diameter(H)


# In[24]:


nx.density(H)


# In[25]:


nx.degree(H)


# In[30]:


I=nx.gnp_random_graph(5,0.70)


# In[31]:


nx.draw(I,with_labels=True)


# In[32]:


nx.density(I)


# In[33]:


nx.diameter(I)

